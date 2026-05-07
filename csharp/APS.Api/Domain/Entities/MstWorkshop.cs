using APS.Domain.ValueObjects;

namespace APS.Domain.Entities;

/// <summary>
/// 车间主数据实体
/// </summary>
public class MstWorkshop
{
    public long Id { get; set; }
    public long FactoryId { get; set; }
    public string WorkshopCode { get; set; } = string.Empty;
    public string WorkshopName { get; set; } = string.Empty;
    public string? WorkshopType { get; set; }
    public decimal? AreaSqm { get; set; }
    public string? Description { get; set; }
    public bool IsActive { get; set; } = true;
    public int VersionFlag { get; set; } = 0;

    // 审计字段
    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    // 导航
    public MstFactory? Factory { get; set; }
    public ICollection<MstWorkCenter> WorkCenters { get; set; } = new List<MstWorkCenter>();
}

/// <summary>
/// 工作中心/产线主数据实体
/// </summary>
public class MstWorkCenter
{
    public long Id { get; set; }
    public long WorkshopId { get; set; }
    public string WorkCenterCode { get; set; } = string.Empty;
    public string WorkCenterName { get; set; } = string.Empty;
    public string WcType { get; set; } = string.Empty;
    public string? Category { get; set; }
    public bool IsLine { get; set; } = true;
    public string? Description { get; set; }
    public bool IsActive { get; set; } = true;
    public int VersionFlag { get; set; } = 0;

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstWorkshop? Workshop { get; set; }
    public ICollection<MstMachine> Machines { get; set; } = new List<MstMachine>();
    public ICollection<MstRoutingOperation> RoutingOperations { get; set; } = new List<MstRoutingOperation>();
}

/// <summary>
/// 设备主数据实体
/// </summary>
public class MstMachine
{
    public long Id { get; set; }
    public long WorkCenterId { get; set; }
    public string MachineCode { get; set; } = string.Empty;
    public string MachineName { get; set; } = string.Empty;
    public string MachineType { get; set; } = string.Empty;
    public string? BrandModel { get; set; }
    public string? SerialNo { get; set; }
    public string Status { get; set; } = "IDLE";
    public bool SkillRequired { get; set; } = false;
    public decimal SetupHours { get; set; } = 0.5m;
    public int CycleTimeSec { get; set; } = 60;
    public decimal? MaxSpeedPcsHr { get; set; }
    public decimal DailyAvailHours { get; set; } = 22.0m;
    public decimal CostPerHour { get; set; } = 0;
    public string? Location { get; set; }
    public string? Description { get; set; }
    public bool IsActive { get; set; } = true;
    public int VersionFlag { get; set; } = 0;

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstWorkCenter? WorkCenter { get; set; }
    public ICollection<MstMachineSkill> MachineSkills { get; set; } = new List<MstMachineSkill>();
    public ICollection<MstMaintenance> Maintenances { get; set; } = new List<MstMaintenance>();
}

/// <summary>
/// 设备-技能关联实体
/// </summary>
public class MstMachineSkill
{
    public long Id { get; set; }
    public long MachineId { get; set; }
    public long SkillId { get; set; }
    public string Proficiency { get; set; } = "QUALIFIED";
    public DateTime? CertifiedDate { get; set; }
    public DateTime? ExpiryDate { get; set; }
    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstMachine? Machine { get; set; }
    public MstSkill? Skill { get; set; }
}

/// <summary>
/// 技能主数据实体
/// </summary>
public class MstSkill
{
    public long Id { get; set; }
    public string SkillCode { get; set; } = string.Empty;
    public string SkillName { get; set; } = string.Empty;
    public string? SkillCategory { get; set; }
    public string? Description { get; set; }
    public bool IsActive { get; set; } = true;
    public int VersionFlag { get; set; } = 0;

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public ICollection<MstMachineSkill> MachineSkills { get; set; } = new List<MstMachineSkill>();
    public ICollection<MstWorkerSkill> WorkerSkills { get; set; } = new List<MstWorkerSkill>();
    public ICollection<MstRoutingOperation> RoutingOperations { get; set; } = new List<MstRoutingOperation>();
}

/// <summary>
/// 工人主数据实体
/// </summary>
public class MstWorker
{
    public long Id { get; set; }
    public long? WorkshopId { get; set; }
    public string WorkerCode { get; set; } = string.Empty;
    public string WorkerName { get; set; } = string.Empty;
    public string? IdCardNo { get; set; }
    public string? Phone { get; set; }
    public string? Email { get; set; }
    public string Status { get; set; } = "ACTIVE";
    public bool IsActive { get; set; } = true;
    public int VersionFlag { get; set; } = 0;

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstWorkshop? Workshop { get; set; }
    public ICollection<MstWorkerSkill> WorkerSkills { get; set; } = new List<MstWorkerSkill>();
}

/// <summary>
/// 工人-技能关联实体
/// </summary>
public class MstWorkerSkill
{
    public long Id { get; set; }
    public long WorkerId { get; set; }
    public long SkillId { get; set; }
    public string Proficiency { get; set; } = "QUALIFIED";
    public DateTime? CertifiedDate { get; set; }
    public DateTime? ExpiryDate { get; set; }
    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstWorker? Worker { get; set; }
    public MstSkill? Skill { get; set; }
}

/// <summary>
/// 设备保养记录实体
/// </summary>
public class MstMaintenance
{
    public long Id { get; set; }
    public long MachineId { get; set; }
    public string MaintenanceType { get; set; } = string.Empty;
    public DateTime PlannedDate { get; set; }
    public DateTime? ActualDate { get; set; }
    public string Description { get; set; } = string.Empty;
    public string Status { get; set; } = "PLANNED";
    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstMachine? Machine { get; set; }
}
