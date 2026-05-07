namespace APS.Domain.Enums;

/// <summary>
/// 工厂类型
/// </summary>
public enum FactoryType
{
    /// <summary>电子组装</summary>
    ELECTRONIC_ASSEMBLY,
    /// <summary>机加工</summary>
    MACHINING,
    /// <summary>批次加工（热处理、电镀、喷涂）</summary>
    BATCH
}

/// <summary>
/// 车间类型
/// </summary>
public enum WorkshopType
{
    SMT,
    CNC,
    ASSEMBLY,
    BATCH,
    TEST,
    WAREHOUSE,
    QA
}

/// <summary>
/// 工作中心类型
/// </summary>
public enum WorkCenterType
{
    ASSEMBLY,
    MACHINING,
    BATCH,
    SMT,
    TEST,
    QA,
    WAREHOUSE
}

/// <summary>
/// 设备状态
/// </summary>
public enum MachineStatus
{
    IDLE,
    RUNNING,
    MAINTENANCE,
    FAULT,
    OFFLINE
}

/// <summary>
/// 工人技能等级
/// </summary>
public enum SkillProficiency
{
    TRAINEE,
    QUALIFIED,
    ADVANCED,
    EXPERT
}

/// <summary>
/// 技能类别
/// </summary>
public enum SkillCategory
{
    OPERATOR,
    TECHNICIAN,
    QUALITY,
    MAINTENANCE
}

/// <summary>
/// 物料类型
/// </summary>
public enum ItemType
{
    FINISHED_GOOD,
    SEMI_FINISHED,
    RAW_MATERIAL,
    CONSUMABLE,
    TOOL
}

/// <summary>
/// 班次类型
/// </summary>
public enum ShiftType
{
    DAY,
    NIGHT,
    SWING
}

/// <summary>
/// BOM 类型
/// </summary>
public enum BomType
{
    STANDARD,
    ENGINEERING,
    OPTIONAL
}

/// <summary>
/// 工艺路线类型
/// </summary>
public enum RoutingType
{
    STANDARD,
    OPTIONAL,
    REPAIR
}

/// <summary>
/// 工序类型
/// </summary>
public enum OperationType
{
    NORMAL,
    BATCH,
    SETUP,
    TEARDOWN,
    QA
}

/// <summary>
/// 工单状态
/// </summary>
public enum WorkOrderStatus
{
    DRAFT,
    RELEASED,
    IN_PROGRESS,
    COMPLETED,
    CLOSED,
    PARTIAL,
    REPAIR,
    CANCELLED
}

/// <summary>
/// 工单优先级
/// </summary>
public enum WorkOrderPriority
{
    URGENT = 1,
    HIGH = 2,
    NORMAL = 3,
    LOW = 4
}

/// <summary>
/// 排程版本状态
/// </summary>
public enum ScheduleStatus
{
    DRAFT,
    PUBLISHED,
    IN_PROGRESS,
    COMPLETED,
    ARCHIVED
}

/// <summary>
/// 工序排程状态
/// </summary>
public enum OperationScheduleStatus
{
    WAITING,
    READY,
    IN_PROGRESS,
    COMPLETED,
    REJECTED,
    SKIPPED
}

/// <summary>
/// 异常等级
/// </summary>
public enum ExceptionLevel
{
    INFO,
    WARNING,
    ERROR,
    CRITICAL
}

/// <summary>
/// 异常类型
/// </summary>
public enum ExceptionType
{
    MATERIAL_SHORTAGE,
    QUALITY_REJECT,
    MACHINE_BREAKDOWN,
    DELIVERY_RISK,
    CAPACITY_OVERLOAD,
    DEADLINE_MISS,
    SKILL_MISMATCH,
    BOM_INCOMPLETE,
    ROUTING_MISSING,
    KITting_INCOMPLETE
}

/// <summary>
/// 通知类型
/// </summary>
public enum NotificationType
{
    SCHEDULE_PUBLISHED,
    WORK_ORDER_RELEASED,
    EXCEPTION_ALERT,
    MATERIAL_ALERT,
    DELIVERY_WARNING,
    SYSTEM
}

/// <summary>
/// 用户状态
/// </summary>
public enum UserStatus
{
    ACTIVE,
    INACTIVE,
    LOCKED
}
