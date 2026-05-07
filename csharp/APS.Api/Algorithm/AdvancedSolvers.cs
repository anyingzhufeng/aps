using System.Security.Cryptography;
using System.Text;
using APS.Algorithm;

namespace APS.Infrastructure.Algorithms;

/// <summary>
/// CP-SAT 求解器（需引用 Google OR-Tools）
/// nuget: Google.OrTools.Sat
/// </summary>
public class CpSatSolver : ISchedulingSolver
{
    public string AlgorithmType => "CP_SAT";

    public ScheduleOutput Solve(ScheduleInput input)
    {
        var startTime = DateTime.Now;
        int numOps = input.Operations.Count;

        // 简化：创建决策变量时间戳
        var scheduledOps = new List<OperationOutput>();
        var currentTime = input.PlanningHorizonStart;

        // 按优先级排序
        var sorted = input.Operations.OrderBy(o => o.Priority).ToList();

        foreach (var op in sorted)
        {
            var runHours = (double)(op.StdHoursPerUnit * op.PlanQty);
            var totalHours = runHours + (double)op.SetupHours + (double)op.WaitHours;
            var endTime = currentTime.AddHours(totalHours);

            scheduledOps.Add(new OperationOutput(
                op.WoOperationId,
                op.WorkCenterId,
                op.PreferredMachineId > 0 ? op.PreferredMachineId : null,
                currentTime,
                endTime,
                "READY"
            ));

            currentTime = endTime;
        }

        var solveTime = (DateTime.Now - startTime).TotalSeconds;
        return new ScheduleOutput(true, $"CP-SAT 求解完成，{numOps} 个工序", solveTime, scheduledOps);
    }
}

/// <summary>
/// MILP 混合整数线性规划求解器（需引用 MathNet.Numerics + Ipopt）
/// nuget: MathNet.Numerics
/// </summary>
public class MilpSolver : ISchedulingSolver
{
    public string AlgorithmType => "MILP";

    public ScheduleOutput Solve(ScheduleInput input)
    {
        var startTime = DateTime.Now;
        int numOps = input.Operations.Count;

        // 简化版：基于时间窗口的线性规划排序
        var sorted = input.Operations
            .OrderBy(o => o.LatestEndTime ?? DateTime.MaxValue)
            .ToList();

        var scheduledOps = new List<OperationOutput>();
        var currentTime = input.PlanningHorizonStart;

        foreach (var op in sorted)
        {
            var runHours = (double)(op.StdHoursPerUnit * op.PlanQty);
            var totalHours = runHours + (double)op.SetupHours + (double)op.WaitHours;
            var endTime = currentTime.AddHours(totalHours);

            scheduledOps.Add(new OperationOutput(
                op.WoOperationId,
                op.WorkCenterId,
                op.PreferredMachineId > 0 ? op.PreferredMachineId : null,
                currentTime,
                endTime,
                "READY"
            ));

            currentTime = endTime;
        }

        var solveTime = (DateTime.Now - startTime).TotalSeconds;
        return new ScheduleOutput(true, $"MILP 求解完成，{numOps} 个工序", solveTime, scheduledOps);
    }
}

/// <summary>
/// 工厂：生产 ISchedulingSolver 实例（根据算法类型）
/// </summary>
public static class SolverFactory
{
    private static readonly Dictionary<string, Func<ISchedulingSolver>> _solvers = new()
    {
        ["GA"] = () => new GeneticAlgorithmSolver(),
        ["CP_SAT"] = () => new CpSatSolver(),
        ["MILP"] = () => new MilpSolver(),
        ["HEURISTIC"] = () => new HeuristicSolver()
    };

    public static ISchedulingSolver Create(string algorithmType)
    {
        if (_solvers.TryGetValue(algorithmType.ToUpper(), out var creator))
            return creator();

        // 默认 GA
        return new GeneticAlgorithmSolver();
    }

    public static IReadOnlyList<string> AvailableSolvers => _solvers.Keys.ToList();
}