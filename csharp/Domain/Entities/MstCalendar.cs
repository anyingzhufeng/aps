namespace APS.Domain.Entities;

/// <summary>
/// 生产日历实体
/// </summary>
public class MstCalendar
{
    public long Id { get; set; }
    public long FactoryId { get; set; }
    public string CalendarCode { get; set; } = string.Empty;
    public string CalendarName { get; set; } = string.Empty;
    public string CalType { get; set; } = "FACTORY";
    public long? RefId { get; set; }
    public bool IsActive { get; set; } = true;
    public int VersionFlag { get; set; } = 0;

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstFactory? Factory { get; set; }
    public ICollection<MstShift> Shifts { get; set; } = new List<MstShift>();
    public ICollection<MstHoliday> Holidays { get; set; } = new List<MstHoliday>();
}

/// <summary>
/// 班次定义实体
/// </summary>
public class MstShift
{
    public long Id { get; set; }
    public long CalendarId { get; set; }
    public string ShiftCode { get; set; } = string.Empty;
    public string ShiftName { get; set; } = string.Empty;
    public string ShiftType { get; set; } = "DAY";
    public TimeSpan StartTime { get; set; }
    public TimeSpan EndTime { get; set; }
    public int BreakMinutes { get; set; } = 60;
    public DateTime EffectiveDate { get; set; }
    public DateTime? ExpiryDate { get; set; }
    public bool IsActive { get; set; } = true;

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstCalendar? Calendar { get; set; }
    public ICollection<MstWorkerShift> WorkerShifts { get; set; } = new List<MstWorkerShift>();
}

/// <summary>
/// 节假日实体
/// </summary>
public class MstHoliday
{
    public long Id { get; set; }
    public long CalendarId { get; set; }
    public string HolidayName { get; set; } = string.Empty;
    public DateTime HolidayDate { get; set; }
    public int DurationDays { get; set; } = 1;
    public bool IsPaidHoliday { get; set; } = true;
    public string? Remarks { get; set; }

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstCalendar? Calendar { get; set; }
}

/// <summary>
/// 工人-班次关联实体
/// </summary>
public class MstWorkerShift
{
    public long Id { get; set; }
    public long WorkerId { get; set; }
    public long ShiftId { get; set; }
    public DateTime EffectiveDate { get; set; }
    public DateTime? ExpiryDate { get; set; }
    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstWorker? Worker { get; set; }
    public MstShift? Shift { get; set; }
}
