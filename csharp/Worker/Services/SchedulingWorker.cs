using APS.Domain.Entities;
using APS.Domain.Enums;
using APS.Algorithm;
using APS.Infrastructure.Repositories;

namespace APS.Worker.Services;

/// <summary>
/// 排程后台 Worker 服务
/// 定时扫描待排工单，触发排程引擎，发布结果
/// </summary>
public class SchedulingWorker : BackgroundService
{
    private readonly ILogger<SchedulingWorker> _logger;
    private readonly IServiceProvider _serviceProvider;
    private readonly TimeSpan _scanInterval = TimeSpan.FromMinutes(5);

    public SchedulingWorker(ILogger<SchedulingWorker> logger, IServiceProvider serviceProvider)
    {
        _logger = logger;
        _serviceProvider = serviceProvider;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("排程 Worker 已启动");
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await RunSchedulingCycleAsync(stoppingToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "排程循环异常");
            }
            await Task.Delay(_scanInterval, stoppingToken);
        }
    }

    private async Task RunSchedulingCycleAsync(CancellationToken ct)
    {
        using var scope = _serviceProvider.CreateScope();
        var woRepo = scope.ServiceProvider.GetRequiredService<IWorkOrderRepository>();
        var schRepo = scope.ServiceProvider.GetRequiredService<IScheduleRepository>();

        // 取出所有已发布但未排程的工单
        var pendingWos = await woRepo.GetReleasedPendingScheduleAsync(factoryId: 1);

        if (pendingWos.Count == 0)
        {
            _logger.LogDebug("无待排工单，跳过本轮");
            return;
        }

        _logger.LogInformation("发现 {Count} 个待排工单，开始排程", pendingWos.Count);

        // 构造排程输入
        var operations = new List<OperationInput>();
        foreach (var wo in pendingWos)
        {
            foreach (var op in wo.Operations)
            {
                var routingOp = op.RoutingOperation;
                operations.Add(new OperationInput(
                    WoOperationId: op.Id,
                    WorkCenterId: op.WorkCenterId,
                    PreferredMachineId: op.MachineId,
                    PlanQty: op.PlanQty,
                    StdHoursPerUnit: op.StdHoursPerUnit > 0 ? op.StdHoursPerUnit : 1.0m,
                    SetupHours: op.SetupHours,
                    WaitHours: op.WaitHours,
                    EarliestStartTime: wo.PlannedStartDate ?? DateTime.Today,
                    LatestEndTime: wo.RequiredDate ?? DateTime.Today.AddDays(7),
                    Priority: (int)(wo.Priority ?? 3)
                ));
            }
        }

        var input = new ScheduleInput(
            FactoryId: 1,
            Operations: operations,
            WorkCenters: new List<ResourceInput>(), // 简化，实际从DB查
            Machines: new List<ResourceInput>(),
            PlanningHorizonStart: DateTime.Today,
            PlanningHorizonEnd: DateTime.Today.AddDays(14)
        );

        // 选择求解器（默认 GA）
        ISchedulingSolver solver = new GeneticAlgorithmSolver();
        var output = solver.Solve(input);

        // 保存排程结果
        var scheduleResult = new SchScheduleResult
        {
            ScheduleCode = $"SCH-{DateTime.Now:yyyyMMddHHmm}-V{Random.Shared.Next(1, 99):D2}",
            FactoryId = 1,
            ScheduleDate = DateTime.Today,
            Status = ScheduleStatus.DRAFT.ToString(),
            AlgorithmType = solver.AlgorithmType,
            TotalWoCount = pendingWos.Count,
            TotalOpCount = operations.Count,
            ScheduledOpCount = output.Operations.Count,
            UnscheduledOpCount = operations.Count - output.Operations.Count,
            SolveTimeSeconds = output.SolveTimeSeconds,
            CreatedBy = "SchedulingWorker",
            CreatedAt = DateTime.UtcNow,
            UpdatedBy = "SchedulingWorker",
            UpdatedAt = DateTime.UtcNow
        };

        // 写工序明细
        foreach (var opOut in output.Operations)
        {
            scheduleResult.Operations.Add(new SchOperation
            {
                ScheduleResultId = scheduleResult.Id,
                WoOperationId = opOut.WoOperationId,
                WorkCenterId = opOut.WorkCenterId,
                MachineId = opOut.MachineId,
                ScheduledStartTime = opOut.ScheduledStartTime,
                ScheduledEndTime = opOut.ScheduledEndTime,
                SetupHours = 0,
                RunHours = (decimal)(opOut.ScheduledEndTime - opOut.ScheduledStartTime).TotalHours,
                WaitHours = 0,
                MoveHours = 0,
                Status = OperationScheduleStatus.READY.ToString(),
                CreatedBy = "SchedulingWorker",
                CreatedAt = DateTime.UtcNow
            });
        }

        scheduleResult.Status = ScheduleStatus.PUBLISHED.ToString();
        scheduleResult.PublishedAt = DateTime.UtcNow;
        scheduleResult.PublishedBy = "SchedulingWorker";

        await schRepo.AddAsync(scheduleResult);

        _logger.LogInformation(
            "排程完成：{Code} / 算法={Alg} / 工序={Ops} / 耗时={Time:F2}秒",
            scheduleResult.ScheduleCode,
            solver.AlgorithmType,
            output.Operations.Count,
            output.SolveTimeSeconds
        );
    }
}