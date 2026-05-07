namespace APS.Domain.Entities;

/// <summary>
/// 工单主数据实体
/// </summary>
public class OrdWorkOrder
{
    public long Id { get; set; }
    public string WoNumber { get; set; } = string.Empty;
    public string WoType { get; set; } = "NORMAL";
    public long ItemId { get; set; }
    public long? BomId { get; set; }
    public long? RoutingId { get; set; }
    public decimal PlanQty { get; set; }
    public decimal? CompletedQty { get; set; }
    public decimal? ScrapQty { get; set; }
    public string UnitCode { get; set; } = "PCS";
    public decimal? Priority { get; set; } = 3;
    public DateTime? RequiredDate { get; set; }
    public DateTime? PromiseDate { get; set; }
    public DateTime? PlannedStartDate { get; set; }
    public DateTime? PlannedEndDate { get; set; }
    public DateTime? ActualStartDate { get; set; }
    public DateTime? ActualEndDate { get; set; }
    public long? CustomerId { get; set; }
    public string? CustomerPoNo { get; set; }
    public string? SalesOrderNo { get; set; }
    public string Status { get; set; } = "DRAFT";
    public string? Description { get; set; }
    public string? Remarks { get; set; }
    public int VersionFlag { get; set; } = 0;

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    // 导航
    public MstItem? Item { get; set; }
    public MstBom? Bom { get; set; }
    public MstRouting? Routing { get; set; }
    public ICollection<OrdWorkOrderItem> WoItems { get; set; } = new List<OrdWorkOrderItem>();
    public ICollection<OrdWoOperation> Operations { get; set; } = new List<OrdWoOperation>();
    public ICollection<SchScheduleResult> ScheduleResults { get; set; } = new List<SchScheduleResult>();
    public ICollection<ExcWorkOrderException> Exceptions { get; set; } = new List<ExcWorkOrderException>();
    public ICollection<InvWoKitting> Kittings { get; set; } = new List<InvWoKitting>();
}

/// <summary>
/// 工单子项实体（客制化配置）
/// </summary>
public class OrdWorkOrderItem
{
    public long Id { get; set; }
    public long WorkOrderId { get; set; }
    public long ItemId { get; set; }
    public int LineNo { get; set; }
    public decimal PlanQty { get; set; }
    public decimal? AllocatedQty { get; set; }
    public decimal? ConsumedQty { get; set; }
    public string? Remarks { get; set; }

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public OrdWorkOrder? WorkOrder { get; set; }
    public MstItem? Item { get; set; }
}

/// <summary>
/// 工单工序明细实体（可排程的最小单元）
/// </summary>
public class OrdWoOperation
{
    public long Id { get; set; }
    public long WorkOrderId { get; set; }
    public long RoutingOperationId { get; set; }
    public int OpSeq { get; set; }
    public string OpCode { get; set; } = string.Empty;
    public string OpName { get; set; } = string.Empty;
    public long WorkCenterId { get; set; }
    public long? MachineId { get; set; }
    public long? WorkerId { get; set; }
    public decimal PlanQty { get; set; }
    public decimal? CompletedQty { get; set; }
    public decimal StdHoursPerUnit { get; set; }
    public decimal SetupHours { get; set; } = 0;
    public decimal WaitHours { get; set; } = 0;
    public DateTime? PlannedStartTime { get; set; }
    public DateTime? PlannedEndTime { get; set; }
    public DateTime? ActualStartTime { get; set; }
    public DateTime? ActualEndTime { get; set; }
    public string Status { get; set; } = "WAITING";
    public string? Remarks { get; set; }

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public OrdWorkOrder? WorkOrder { get; set; }
    public MstRoutingOperation? RoutingOperation { get; set; }
    public MstWorkCenter? WorkCenter { get; set; }
    public MstMachine? Machine { get; set; }
    public MstWorker? Worker { get; set; }
}
