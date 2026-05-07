namespace APS.Domain.Entities;

/// <summary>
/// 工单异常实体
/// </summary>
public class ExcWorkOrderException
{
    public long Id { get; set; }
    public long WorkOrderId { get; set; }
    public long? WoOperationId { get; set; }
    public string ExceptionCode { get; set; } = string.Empty;
    public string ExceptionType { get; set; } = string.Empty;
    public string Level { get; set; } = "WARNING";
    public string? Description { get; set; }
    public string? CauseAnalysis { get; set; }
    public string? SuggestedAction { get; set; }
    public string Status { get; set; } = "OPEN";
    public string? Resolver { get; set; }
    public DateTime? ResolvedAt { get; set; }
    public string? Resolution { get; set; }
    public string? Remarks { get; set; }

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public OrdWorkOrder? WorkOrder { get; set; }
    public OrdWoOperation? WoOperation { get; set; }
}

/// <summary>
/// 系统通知实体
/// </summary>
public class SysNotification
{
    public long Id { get; set; }
    public string NotificationType { get; set; } = "SYSTEM";
    public string Title { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public string? TargetUser { get; set; }
    public long? TargetWorkOrderId { get; set; }
    public long? TargetExceptionId { get; set; }
    public string Channel { get; set; } = "IN_APP";
    public string Status { get; set; } = "UNREAD";
    public DateTime? ReadAt { get; set; }
    public DateTime? ExpiresAt { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;
}

/// <summary>
/// 用户实体
/// </summary>
public class SysUser
{
    public long Id { get; set; }
    public string Username { get; set; } = string.Empty;
    public string? Email { get; set; }
    public string? Phone { get; set; }
    public string PasswordHash { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public string Status { get; set; } = "ACTIVE";
    public bool IsActive { get; set; } = true;

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string UpdatedBy { get; set; } = "system";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public ICollection<SysUserRole> UserRoles { get; set; } = new List<SysUserRole>();
}

/// <summary>
/// 角色实体
/// </summary>
public class SysRole
{
    public long Id { get; set; }
    public string RoleCode { get; set; } = string.Empty;
    public string RoleName { get; set; } = string.Empty;
    public string? Description { get; set; }
    public bool IsActive { get; set; } = true;

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public ICollection<SysUserRole> UserRoles { get; set; } = new List<SysUserRole>();
    public ICollection<SysRolePermission> RolePermissions { get; set; } = new List<SysRolePermission>();
}

/// <summary>
/// 用户-角色关联
/// </summary>
public class SysUserRole
{
    public long Id { get; set; }
    public long UserId { get; set; }
    public long RoleId { get; set; }
    public DateTime AssignedAt { get; set; } = DateTime.UtcNow;
    public string? AssignedBy { get; set; }
    public bool IsDeleted { get; set; } = false;

    public SysUser? User { get; set; }
    public SysRole? Role { get; set; }
}

/// <summary>
/// 权限实体
/// </summary>
public class SysPermission
{
    public long Id { get; set; }
    public string PermissionCode { get; set; } = string.Empty;
    public string PermissionName { get; set; } = string.Empty;
    public string? MenuCode { get; set; }
    public string? Description { get; set; }
    public bool IsActive { get; set; } = true;

    public string CreatedBy { get; set; } = "system";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public ICollection<SysRolePermission> RolePermissions { get; set; } = new List<SysRolePermission>();
}

/// <summary>
/// 角色-权限关联
/// </summary>
public class SysRolePermission
{
    public long Id { get; set; }
    public long RoleId { get; set; }
    public long PermissionId { get; set; }
    public DateTime AssignedAt { get; set; } = DateTime.UtcNow;
    public bool IsDeleted { get; set; } = false;

    public SysRole? Role { get; set; }
    public SysPermission? Permission { get; set; }
}

/// <summary>
/// 审计日志实体
/// </summary>
public class SysAuditLog
{
    public long Id { get; set; }
    public string UserName { get; set; } = string.Empty;
    public string Action { get; set; } = string.Empty;
    public string EntityType { get; set; } = string.Empty;
    public long? EntityId { get; set; }
    public string? Changes { get; set; }
    public string? IpAddress { get; set; }
    public string? UserAgent { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}

/// <summary>
/// 接口日志实体（记录与 ERP/MES/WMS 的同步历史）
/// </summary>
public class IntInterfaceLog
{
    public long Id { get; set; }
    public string InterfaceCode { get; set; } = string.Empty;
    public string Direction { get; set; } = "INBOUND";
    public string? ExternalSystem { get; set; }
    public string? ExternalRefNo { get; set; }
    public string RequestPayload { get; set; } = string.Empty;
    public string? ResponsePayload { get; set; }
    public string Status { get; set; } = "PENDING";
    public string? ErrorMessage { get; set; }
    public int RetryCount { get; set; } = 0;
    public DateTime? NextRetryAt { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? CompletedAt { get; set; }
    public bool IsDeleted { get; set; } = false;
}
