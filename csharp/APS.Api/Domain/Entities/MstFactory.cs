namespace APS.Domain.Entities;

/// <summary>
/// 工厂主数据实体
/// </summary>
public class MstFactory
{
    public long Id { get; set; }
    public string FactoryCode { get; set; } = string.Empty;
    public string FactoryName { get; set; } = string.Empty;
    public string? FactoryType { get; set; }
    public string? Region { get; set; }
    public string? Address { get; set; }
    public string? ContactName { get; set; }
    public string? ContactPhone { get; set; }
    public string? ContactEmail { get; set; }
    public DateTime? EstablishedDate { get; set; }
    public int Status { get; set; } = 1;
    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime? UpdatedAt { get; set; }
    public bool IsDeleted { get; set; } = false;
}
