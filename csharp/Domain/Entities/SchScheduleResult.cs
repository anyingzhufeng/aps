namespace APS.Domain.Entities;

/// <summary>
/// 排程结果记录（每次排程生成一个版本）
/// </summary>
public class SchScheduleResult
{
    public long Id { get; set; }
    public string ScheduleCode { get; set; } = string.Empty;
    public long FactoryId { get; set; }
    public DateTime ScheduleDate { get; set; }
    public string ScheduleType { get; set; } = "AUTO";
    public string Status { get; set; } = "DRAFT";
    public DateTime? FrozenTime { get; set; }
    public int TotalWoCount { get; set; }
    public int TotalOpCount { get; set; }
    public int? ScheduledWoCount { get; set; }
    public int? ScheduledOpCount { get; set; }
    public int? UnscheduledOpCount { get; set; }
    public DateTime? PublishedAt { get; set; }
    public string? PublishedBy { get; set; }
    public DateTime? EffectiveStartTime { get; set; }
    public DateTime? EffectiveEndTime { get; set; }
    public string? AlgorithmType { get; set; }
    public double? SolveTimeSeconds { get; set; }
    public decimal? TotalCost { get; set; }
    public decimal? UtilizationPct { get; set; }
    public int VersionNo { get; set; } = 1;
    public string? Remarks { get; set; }

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstFactory? Factory { get; set; }
    public ICollection<SchOperation> Operations { get; set; } = new List<SchOperation>();
    public ICollection<SchScheduleLog> Logs { get; set; } = new List<SchScheduleLog>();
}

/// <summary>
/// 工序排程结果明细（每道工序的时间窗口安排）
/// </summary>
public class SchOperation
{
    public long Id { get; set; }
    public long ScheduleResultId { get; set; }
    public long WoOperationId { get; set; }
    public long WorkCenterId { get; set; }
    public long? MachineId { get; set; }
    public long? WorkerId { get; set; }
    public DateTime ScheduledStartTime { get; set; }
    public DateTime ScheduledEndTime { get; set; }
    public decimal SetupHours { get; set; }
    public decimal RunHours { get; set; }
    public decimal WaitHours { get; set; }
    public decimal MoveHours { get; set; }
    public string Status { get; set; } = "WAITING";
    public string? Remarks { get; set; }
    public string? GanttColor { get; set; }

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public SchScheduleResult? ScheduleResult { get; set; }
    public OrdWoOperation? WoOperation { get; set; }
    public MstWorkCenter? WorkCenter { get; set; }
    public MstMachine? Machine { get; set; }
    public MstWorker? Worker { get; set; }
}

/// <summary>
/// 排程日志（记录每次排程引擎的执行过程）
/// </summary>
public class SchScheduleLog
{
    public long Id { get; set; }
    public long ScheduleResultId { get; set; }
    public string LogLevel { get; set; } = "INFO";
    public string LogType { get; set; } = "ENGINE";
    public string Message { get; set; } = string.Empty;
    public string? AlgorithmStep { get; set; }
    public double? ElapsedMs { get; set; }
    public string? Details { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public SchScheduleResult? ScheduleResult { get; set; }
}

/// <summary>
/// 排程参数配置（GA/CP-SAT/MILP 各参数）
/// </summary>
public class SchSolveParam
{
    public long Id { get; set; }
    public string ParamGroup { get; set; } = string.Empty;
    public string ParamKey { get; set; } = string.Empty;
    public string ParamValue { get; set; } = string.Empty;
    public string DataType { get; set; } = "STRING";
    public string? Description { get; set; }
    public bool IsActive { get; set; } = true;

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;
}
