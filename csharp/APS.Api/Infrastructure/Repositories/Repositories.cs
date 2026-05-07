using System.Linq.Expressions;
using Microsoft.EntityFrameworkCore;
using APS.Domain.Entities;
using APS.Infrastructure.Data;

namespace APS.Infrastructure.Repositories;

/// <summary>
/// 通用仓储实现
/// </summary>
public class EfRepository<T> : IRepository<T> where T : class
{
    protected readonly ApsDbContext _context;
    protected readonly DbSet<T> _dbSet;

    public EfRepository(ApsDbContext context)
    {
        _context = context;
        _dbSet = context.Set<T>();
    }

    public async Task<T?> GetByIdAsync(long id)
        => await _dbSet.FindAsync(id);

    public async Task<IReadOnlyList<T>> GetAllAsync()
        => await _dbSet.Where(e => !IsSoftDeleted(e)).ToListAsync();

    public async Task<IReadOnlyList<T>> FindAsync(Expression<Func<T, bool>> predicate)
        => await _dbSet.Where(predicate).Where(e => !IsSoftDeleted(e)).ToListAsync();

    public async Task<T> AddAsync(T entity)
    {
        await _dbSet.AddAsync(entity);
        await _context.SaveChangesAsync();
        return entity;
    }

    public async Task UpdateAsync(T entity)
    {
        _dbSet.Update(entity);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(long id)
    {
        var entity = await GetByIdAsync(id);
        if (entity != null)
        {
            SetDeleted(entity, true);
            await _context.SaveChangesAsync();
        }
    }

    public async Task<int> CountAsync(Expression<Func<T, bool>>? predicate = null)
    {
        var q = _dbSet.Where(e => !IsSoftDeleted(e));
        return predicate != null ? await q.CountAsync(predicate) : await q.CountAsync();
    }

    public async Task<bool> ExistsAsync(Expression<Func<T, bool>> predicate)
        => await _dbSet.IgnoreQueryFilters().AnyAsync(predicate);

    protected static bool IsSoftDeleted(T entity)
    {
        var prop = typeof(T).GetProperty("IsDeleted");
        return prop != null && (bool)(prop.GetValue(entity) ?? false);
    }

    protected void SetDeleted(T entity, bool deleted)
    {
        var prop = typeof(T).GetProperty("IsDeleted");
        if (prop != null) prop.SetValue(entity, deleted);
    }
}

/// <summary>
/// 工单仓储实现
/// </summary>
public class WorkOrderRepository : EfRepository<OrdWorkOrder>, IWorkOrderRepository
{
    public WorkOrderRepository(ApsDbContext context) : base(context) { }

    public async Task<IReadOnlyList<OrdWorkOrder>> GetByStatusAsync(string status)
        => await _context.OrdWorkOrders
            .Where(wo => wo.Status == status && !wo.IsDeleted)
            .Include(wo => wo.Item)
            .ToListAsync();

    public async Task<IReadOnlyList<OrdWorkOrder>> GetReleasedPendingScheduleAsync(long factoryId)
        => await _context.OrdWorkOrders
            .Where(wo => (wo.Status == "RELEASED" || wo.Status == "IN_PROGRESS")
                     && !wo.IsDeleted
                     && wo.Item != null)
            .Include(wo => wo.Item)
            .ThenInclude(it => it!.Routings)
            .Include(wo => wo.Operations)
            .ToListAsync();

    public async Task<OrdWorkOrder?> GetWithOperationsAsync(long id)
        => await _context.OrdWorkOrders
            .Where(wo => wo.Id == id && !wo.IsDeleted)
            .Include(wo => wo.Operations)
            .ThenInclude(op => op.WorkCenter)
            .Include(wo => wo.Operations)
            .ThenInclude(op => op.Machine)
            .FirstOrDefaultAsync();
}

/// <summary>
/// 排程结果仓储实现
/// </summary>
public class ScheduleRepository : EfRepository<SchScheduleResult>, IScheduleRepository
{
    public ScheduleRepository(ApsDbContext context) : base(context) { }

    public async Task<SchScheduleResult?> GetWithOperationsAsync(long id)
        => await _context.SchScheduleResults
            .Where(s => s.Id == id && !s.IsDeleted)
            .Include(s => s.Operations)
            .ThenInclude(op => op.WorkCenter)
            .Include(s => s.Operations)
            .ThenInclude(op => op.Machine)
            .FirstOrDefaultAsync();

    public async Task<IReadOnlyList<SchScheduleResult>> GetByFactoryAndDateAsync(long factoryId, DateTime date)
        => await _context.SchScheduleResults
            .Where(s => s.FactoryId == factoryId && s.ScheduleDate == date && !s.IsDeleted)
            .OrderByDescending(s => s.VersionNo)
            .ToListAsync();

    public async Task<SchScheduleResult?> GetLatestPublishedAsync(long factoryId)
        => await _context.SchScheduleResults
            .Where(s => s.FactoryId == factoryId && s.Status == "PUBLISHED" && !s.IsDeleted)
            .OrderByDescending(s => s.ScheduleDate)
            .FirstOrDefaultAsync();
}

/// <summary>
/// 物料库存仓储实现
/// </summary>
public class StockRepository : EfRepository<InvMaterialStock>, IStockRepository
{
    public StockRepository(ApsDbContext context) : base(context) { }

    public async Task<InvMaterialStock?> GetByItemAndLotAsync(long itemId, string lotNo)
        => await _context.InvMaterialStocks
            .Where(s => s.ItemId == itemId && s.LotNo == lotNo && !s.IsDeleted)
            .FirstOrDefaultAsync();

    public async Task<IReadOnlyList<InvMaterialStock>> GetByItemIdAsync(long itemId)
        => await _context.InvMaterialStocks
            .Where(s => s.ItemId == itemId && !s.IsDeleted)
            .ToListAsync();

    public async Task<decimal> GetAvailableQtyAsync(long itemId, long? warehouseId = null)
    {
        var q = _context.InvMaterialStocks.Where(s => s.ItemId == itemId && !s.IsDeleted);
        if (warehouseId.HasValue)
            q = q.Where(s => s.WarehouseId == warehouseId);
        var stocks = await q.ToListAsync();
        return stocks.Sum(s => s.AvailableQty ?? s.StockQty);
    }
}