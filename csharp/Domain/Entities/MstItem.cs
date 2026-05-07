namespace APS.Domain.Entities;

/// <summary>
/// 物料主数据实体
/// </summary>
public class MstItem
{
    public long Id { get; set; }
    public string ItemCode { get; set; } = string.Empty;
    public string ItemName { get; set; } = string.Empty;
    public string ItemType { get; set; } = string.Empty;
    public string? Category { get; set; }
    public string UnitCode { get; set; } = "PCS";
    public bool BomRequired { get; set; } = true;
    public bool RoutingRequired { get; set; } = true;
    public decimal MinLotSize { get; set; } = 1;
    public decimal? MaxLotSize { get; set; }
    public int? ShelfLifeDays { get; set; }
    public decimal UnitCost { get; set; } = 0;
    public decimal? WeightKg { get; set; }
    public decimal? VolumeCbm { get; set; }
    public bool IsActive { get; set; } = true;
    public int VersionFlag { get; set; } = 0;

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    // 导航
    public ICollection<MstBom> ParentBoms { get; set; } = new List<MstBom>();
    public ICollection<MstBomLine> ChildBomLines { get; set; } = new List<MstBomLine>();
    public ICollection<MstRouting> Routings { get; set; } = new List<MstRouting>();
    public ICollection<InvMaterialStock> Stocks { get; set; } = new List<InvMaterialStock>();
}

/// <summary>
/// 物料单位
/// </summary>
public class MstUnit
{
    public long Id { get; set; }
    public string UnitCode { get; set; } = string.Empty;
    public string UnitName { get; set; } = string.Empty;
    public string? Description { get; set; }
    public bool IsActive { get; set; } = true;

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;
}

/// <summary>
/// BOM 表头实体
/// </summary>
public class MstBom
{
    public long Id { get; set; }
    public long ItemId { get; set; }
    public string Version { get; set; } = "V1.0";
    public string BomType { get; set; } = "STANDARD";
    public bool IsActive { get; set; } = true;
    public DateTime? EffectiveDate { get; set; }
    public DateTime? ObsoleteDate { get; set; }
    public string? Description { get; set; }
    public int VersionFlag { get; set; } = 0;

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstItem? Item { get; set; }
    public ICollection<MstBomLine> Lines { get; set; } = new List<MstBomLine>();
}

/// <summary>
/// BOM 明细行实体
/// </summary>
public class MstBomLine
{
    public long Id { get; set; }
    public long BomId { get; set; }
    public int LineNo { get; set; }
    public long ChildItemId { get; set; }
    public decimal QtyPerUnit { get; set; }
    public decimal LossRate { get; set; } = 0;
    public bool IsCritical { get; set; } = false;
    public bool IsOptional { get; set; } = false;
    public string? Remarks { get; set; }

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstBom? Bom { get; set; }
    public MstItem? ChildItem { get; set; }
}

/// <summary>
/// 工艺路线表头实体
/// </summary>
public class MstRouting
{
    public long Id { get; set; }
    public long ItemId { get; set; }
    public string Version { get; set; } = "V1.0";
    public string RoutingType { get; set; } = "STANDARD";
    public bool IsActive { get; set; } = true;
    public DateTime? EffectiveDate { get; set; }
    public DateTime? ObsoleteDate { get; set; }
    public decimal? TotalStdHours { get; set; }
    public string? Description { get; set; }
    public int VersionFlag { get; set; } = 0;

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstItem? Item { get; set; }
    public ICollection<MstRoutingOperation> Operations { get; set; } = new List<MstRoutingOperation>();
}

/// <summary>
/// 工艺路线工序明细实体
/// </summary>
public class MstRoutingOperation
{
    public long Id { get; set; }
    public long RoutingId { get; set; }
    public int OpSeq { get; set; }
    public string? OpCode { get; set; }
    public string OpName { get; set; } = string.Empty;
    public long WorkCenterId { get; set; }
    public long? SkillId { get; set; }
    public decimal StdHoursPerUnit { get; set; } = 0;
    public decimal StdHoursPerBatch { get; set; } = 0;
    public int BatchSize { get; set; } = 1;
    public decimal SetupHours { get; set; } = 0;
    public decimal TeardownHours { get; set; } = 0;
    public decimal WaitHours { get; set; } = 0;
    public decimal MoveHours { get; set; } = 0;
    public int OverlapPct { get; set; } = 0;
    public string OpType { get; set; } = "NORMAL";
    public bool IsCritical { get; set; } = false;
    public bool IsQaCheckpoint { get; set; } = false;
    public int? NextOpSeq { get; set; }
    public string? Description { get; set; }

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstRouting? Routing { get; set; }
    public MstWorkCenter? WorkCenter { get; set; }
    public MstSkill? Skill { get; set; }
}
