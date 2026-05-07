namespace APS.Domain.Entities;

/// <summary>
/// 物料库存实体
/// </summary>
public class InvMaterialStock
{
    public long Id { get; set; }
    public long ItemId { get; set; }
    public long? WarehouseId { get; set; }
    public long? LocationId { get; set; }
    public string LotNo { get; set; } = string.Empty;
    public decimal StockQty { get; set; }
    public decimal? AvailableQty { get; set; }
    public decimal? FrozenQty { get; set; }
    public decimal? QCQty { get; set; }
    public string UnitCode { get; set; } = "PCS";
    public DateTime? ExpiryDate { get; set; }
    public DateTime? ShelfLifeDate { get; set; }
    public string? Remarks { get; set; }

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstItem? Item { get; set; }
    public MstLocation? Location { get; set; }
}

/// <summary>
/// 批次/Lot实体
/// </summary>
public class InvLot
{
    public long Id { get; set; }
    public long ItemId { get; set; }
    public string LotNo { get; set; } = string.Empty;
    public string LotStatus { get; set; } = "ACTIVE";
    public decimal Qty { get; set; }
    public string UnitCode { get; set; } = "PCS";
    public DateTime? ExpiryDate { get; set; }
    public DateTime? InDate { get; set; }
    public string? Remarks { get; set; }

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstItem? Item { get; set; }
}

/// <summary>
/// 库位主数据实体
/// </summary>
public class MstLocation
{
    public long Id { get; set; }
    public long? WorkshopId { get; set; }
    public string LocationCode { get; set; } = string.Empty;
    public string LocationName { get; set; } = string.Empty;
    public string? LocationType { get; set; }
    public string? Zone { get; set; }
    public bool IsActive { get; set; } = true;

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public MstWorkshop? Workshop { get; set; }
    public ICollection<InvMaterialStock> Stocks { get; set; } = new List<InvMaterialStock>();
}

/// <summary>
/// 工单齐套检查结果实体
/// </summary>
public class InvWoKitting
{
    public long Id { get; set; }
    public long WorkOrderId { get; set; }
    public long ScheduleResultId { get; set; }
    public string KittingNo { get; set; } = string.Empty;
    public string Status { get; set; } = "PENDING";
    public DateTime? PlannedKittingDate { get; set; }
    public string? Remarks { get; set; }

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public OrdWorkOrder? WorkOrder { get; set; }
    public SchScheduleResult? ScheduleResult { get; set; }
    public ICollection<InvKittingItem> KittingItems { get; set; } = new List<InvKittingItem>();
}

/// <summary>
/// 齐套明细行实体
/// </summary>
public class InvKittingItem
{
    public long Id { get; set; }
    public long KittingId { get; set; }
    public long ItemId { get; set; }
    public decimal RequiredQty { get; set; }
    public decimal? AvailableQty { get; set; }
    public decimal? PickedQty { get; set; }
    public string? LotNo { get; set; }
    public string Status { get; set; } = "PENDING";
    public string? Remarks { get; set; }

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public InvWoKitting? Kitting { get; set; }
    public MstItem? Item { get; set; }
}
