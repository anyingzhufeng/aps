using APS.Domain.Entities;
using APS.Domain.Enums;

namespace APS.Application.Services;

/// <summary>
/// 工单应用服务
/// </summary>
public class WorkOrderService
{
    public OrdWorkOrder CreateWorkOrder(CreateWorkOrderDto dto)
    {
        var wo = new OrdWorkOrder
        {
            WoNumber = GenerateWoNumber(dto.WoType),
            WoType = dto.WoType ?? "NORMAL",
            ItemId = dto.ItemId,
            BomId = dto.BomId,
            RoutingId = dto.RoutingId,
            PlanQty = dto.PlanQty,
            UnitCode = dto.UnitCode ?? "PCS",
            Priority = dto.Priority ?? 3,
            RequiredDate = dto.RequiredDate,
            PromiseDate = dto.PromiseDate,
            Status = WorkOrderStatus.DRAFT.ToString(),
            CreatedBy = "system",
            CreatedAt = DateTime.UtcNow,
            UpdatedBy = "system",
            UpdatedAt = DateTime.UtcNow
        };
        return wo;
    }

    public void ReleaseWorkOrder(OrdWorkOrder wo)
    {
        if (wo.Status != WorkOrderStatus.DRAFT.ToString())
            throw new InvalidOperationException($"只能发布草稿状态的工单，当前状态：{wo.Status}");
        wo.Status = WorkOrderStatus.RELEASED.ToString();
        wo.UpdatedBy = "system";
        wo.UpdatedAt = DateTime.UtcNow;
    }

    public void StartWorkOrder(OrdWorkOrder wo)
    {
        if (wo.Status != WorkOrderStatus.RELEASED.ToString())
            throw new InvalidOperationException($"只能启动已发布的工单，当前状态：{wo.Status}");
        wo.Status = WorkOrderStatus.IN_PROGRESS.ToString();
        wo.ActualStartDate = DateTime.UtcNow;
        wo.UpdatedBy = "system";
        wo.UpdatedAt = DateTime.UtcNow;
    }

    public void CompleteWorkOrder(OrdWorkOrder wo, decimal completedQty)
    {
        wo.CompletedQty = completedQty;
        wo.ActualEndDate = DateTime.UtcNow;
        wo.Status = WorkOrderStatus.COMPLETED.ToString();
        wo.UpdatedBy = "system";
        wo.UpdatedAt = DateTime.UtcNow;
    }

    private static string GenerateWoNumber(string? woType)
    {
        var prefix = woType?.ToUpper() switch
        {
            "REPAIR" => "RP",
            "SAMPLE" => "SA",
            "NORMAL" => "WO",
            _ => "WO"
        };
        return $"{prefix}-{DateTime.Now:yyyyMMdd}-{Random.Shared.Next(1000, 9999)}";
    }
}

public class CreateWorkOrderDto
{
    public long ItemId { get; set; }
    public long? BomId { get; set; }
    public long? RoutingId { get; set; }
    public decimal PlanQty { get; set; }
    public string? WoType { get; set; }
    public string? UnitCode { get; set; }
    public decimal? Priority { get; set; }
    public DateTime? RequiredDate { get; set; }
    public DateTime? PromiseDate { get; set; }
}

/// <summary>
/// 排程应用服务
/// </summary>
public class SchedulingService
{
    public SchScheduleResult CreateScheduleResult(long factoryId, string algorithmType)
    {
        var result = new SchScheduleResult
        {
            ScheduleCode = $"SCH-{DateTime.Now:yyyyMMdd}-V{Random.Shared.Next(1, 99):D2}",
            FactoryId = factoryId,
            ScheduleDate = DateTime.Today,
            ScheduleType = "AUTO",
            Status = ScheduleStatus.DRAFT.ToString(),
            AlgorithmType = algorithmType,
            VersionNo = 1,
            CreatedBy = "system",
            CreatedAt = DateTime.UtcNow,
            UpdatedBy = "system",
            UpdatedAt = DateTime.UtcNow
        };
        return result;
    }

    public void Publish(SchScheduleResult result)
    {
        if (result.Status != ScheduleStatus.DRAFT.ToString())
            throw new InvalidOperationException("只能发布草稿状态的排程结果");
        result.Status = ScheduleStatus.PUBLISHED.ToString();
        result.PublishedAt = DateTime.UtcNow;
        result.PublishedBy = "system";
        result.UpdatedBy = "system";
        result.UpdatedAt = DateTime.UtcNow;
    }
}

/// <summary>
/// 齐套检查服务
/// </summary>
public class KittingService
{
    public InvWoKitting CreateKitting(OrdWorkOrder wo, SchScheduleResult schedule)
    {
        var kitting = new InvWoKitting
        {
            KittingNo = $"KIT-{DateTime.Now:yyyyMMdd}-{Random.Shared.Next(1000, 9999)}",
            WorkOrderId = wo.Id,
            ScheduleResultId = schedule.Id,
            Status = "PENDING",
            CreatedBy = "system",
            CreatedAt = DateTime.UtcNow,
            UpdatedBy = "system",
            UpdatedAt = DateTime.UtcNow
        };
        return kitting;
    }

    public bool CheckKittingComplete(InvWoKitting kitting)
    {
        return kitting.KittingItems.All(ki => ki.Status == "PICKED");
    }
}

/// <summary>
/// 异常服务
/// </summary>
public class ExceptionService
{
    public ExcWorkOrderException RaiseException(
        OrdWorkOrder wo,
        string exceptionType,
        string description,
        string level = "WARNING")
    {
        var exc = new ExcWorkOrderException
        {
            WorkOrderId = wo.Id,
            ExceptionCode = $"EXC-{DateTime.Now:yyyyMMdd}-{Random.Shared.Next(1000, 9999)}",
            ExceptionType = exceptionType,
            Level = level,
            Description = description,
            Status = "OPEN",
            CreatedBy = "system",
            CreatedAt = DateTime.UtcNow,
            UpdatedBy = "system",
            UpdatedAt = DateTime.UtcNow
        };
        return exc;
    }

    public void ResolveException(ExcWorkOrderException exc, string resolution)
    {
        exc.Status = "RESOLVED";
        exc.ResolvedAt = DateTime.UtcNow;
        exc.Resolution = resolution;
        exc.UpdatedBy = "system";
        exc.UpdatedAt = DateTime.UtcNow;
    }
}
