using Microsoft.EntityFrameworkCore;
using APS.Domain.Entities;

namespace APS.Infrastructure.Data;

public class ApsDbContext : DbContext
{
    public ApsDbContext(DbContextOptions<ApsDbContext> options) : base(options) { }

    // ===== Master Data =====
    public DbSet<MstFactory> MstFactories => Set<MstFactory>();
    public DbSet<MstWorkshop> MstWorkshops => Set<MstWorkshop>();
    public DbSet<MstWorkCenter> MstWorkCenters => Set<MstWorkCenter>();
    public DbSet<MstMachine> MstMachines => Set<MstMachine>();
    public DbSet<MstMachineSkill> MstMachineSkills => Set<MstMachineSkill>();
    public DbSet<MstSkill> MstSkills => Set<MstSkill>();
    public DbSet<MstWorker> MstWorkers => Set<MstWorker>();
    public DbSet<MstWorkerSkill> MstWorkerSkills => Set<MstWorkerSkill>();
    public DbSet<MstCalendar> MstCalendars => Set<MstCalendar>();
    public DbSet<MstShift> MstShifts => Set<MstShift>();
    public DbSet<MstHoliday> MstHolidays => Set<MstHoliday>();
    public DbSet<MstWorkerShift> MstWorkerShifts => Set<MstWorkerShift>();
    public DbSet<MstItem> MstItems => Set<MstItem>();
    public DbSet<MstUnit> MstUnits => Set<MstUnit>();
    public DbSet<MstBom> MstBoms => Set<MstBom>();
    public DbSet<MstBomLine> MstBomLines => Set<MstBomLine>();
    public DbSet<MstRouting> MstRoutings => Set<MstRouting>();
    public DbSet<MstRoutingOperation> MstRoutingOperations => Set<MstRoutingOperation>();
    public DbSet<MstLocation> MstLocations => Set<MstLocation>();
    public DbSet<MstMaintenance> MstMaintenances => Set<MstMaintenance>();

    // ===== Orders =====
    public DbSet<OrdWorkOrder> OrdWorkOrders => Set<OrdWorkOrder>();
    public DbSet<OrdWorkOrderItem> OrdWorkOrderItems => Set<OrdWorkOrderItem>();
    public DbSet<OrdWoOperation> OrdWoOperations => Set<OrdWoOperation>();

    // ===== Scheduling =====
    public DbSet<SchScheduleResult> SchScheduleResults => Set<SchScheduleResult>();
    public DbSet<SchOperation> SchOperations => Set<SchOperation>();
    public DbSet<SchScheduleLog> SchScheduleLogs => Set<SchScheduleLog>();
    public DbSet<SchSolveParam> SchSolveParams => Set<SchSolveParam>();

    // ===== Inventory =====
    public DbSet<InvMaterialStock> InvMaterialStocks => Set<InvMaterialStock>();
    public DbSet<InvLot> InvLots => Set<InvLot>();
    public DbSet<InvWoKitting> InvWoKittings => Set<InvWoKitting>();
    public DbSet<InvKittingItem> InvKittingItems => Set<InvKittingItem>();

    // ===== Exception / Notification =====
    public DbSet<ExcWorkOrderException> ExcWorkOrderExceptions => Set<ExcWorkOrderException>();
    public DbSet<SysNotification> SysNotifications => Set<SysNotification>();
    public DbSet<SysAuditLog> SysAuditLogs => Set<SysAuditLog>();
    public DbSet<IntInterfaceLog> IntInterfaceLogs => Set<IntInterfaceLog>();

    // ===== System / Auth =====
    public DbSet<SysUser> SysUsers => Set<SysUser>();
    public DbSet<SysRole> SysRoles => Set<SysRole>();
    public DbSet<SysUserRole> SysUserRoles => Set<SysUserRole>();
    public DbSet<SysPermission> SysPermissions => Set<SysPermission>();
    public DbSet<SysRolePermission> SysRolePermissions => Set<SysRolePermission>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // 全局查询过滤器：软删除
        foreach (var entityType in modelBuilder.Model.GetEntityTypes())
        {
            if (entityType.ClrType.IsSubclassOf(typeof(BaseEntity)))
            {
                var method = typeof(ModelBuilder).GetMethods()
                    .First(m => m.Name == "HasQueryFilter" && m.GetParameters().Length == 2)
                    .MakeGenericMethod(entityType.ClrType);
                method.Invoke(modelBuilder, new object[] { null, Expression.Lambda(
                    Expression.Constant(false),
                    Expression.Parameter(entityType.ClrType)
                )});
            }
        }

        // 表名统一加前缀
        foreach (var entityType in modelBuilder.Model.GetEntityTypes())
        {
            var tableName = entityType.ClrType.Name
                .Replace("Mst", "mst_")
                .Replace("Ord", "ord_")
                .Replace("Sch", "sch_")
                .Replace("Inv", "inv_")
                .Replace("Exc", "exc_")
                .Replace("Sys", "sys_")
                .Replace("Int", "int_");
            modelBuilder.Entity(entityType.ClrType).ToTable(tableName.ToLower());
        }
    }
}

// 软删除基类（所有实体继承此基类）
public abstract class BaseEntity
{
    public bool IsDeleted { get; set; } = false;
}