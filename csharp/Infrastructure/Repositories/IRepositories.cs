using System.Linq.Expressions;
using APS.Domain.Entities;

namespace APS.Infrastructure.Repositories;

/// <summary>
/// 通用仓储接口
/// </summary>
public interface IRepository<T> where T : class
{
    Task<T?> GetByIdAsync(long id);
    Task<IReadOnlyList<T>> GetAllAsync();
    Task<IReadOnlyList<T>> FindAsync(Expression<Func<T, bool>> predicate);
    Task<T> AddAsync(T entity);
    Task UpdateAsync(T entity);
    Task DeleteAsync(long id);
    Task<int> CountAsync(Expression<Func<T, bool>>? predicate = null);
    Task<bool> ExistsAsync(Expression<Func<T, bool>> predicate);
}

/// <summary>
/// 工单仓储
/// </summary>
public interface IWorkOrderRepository : IRepository<OrdWorkOrder>
{
    Task<IReadOnlyList<OrdWorkOrder>> GetByStatusAsync(string status);
    Task<IReadOnlyList<OrdWorkOrder>> GetReleasedPendingScheduleAsync(long factoryId);
    Task<OrdWorkOrder?> GetWithOperationsAsync(long id);
}

/// <summary>
/// 排程结果仓储
/// </summary>
public interface IScheduleRepository : IRepository<SchScheduleResult>
{
    Task<SchScheduleResult?> GetWithOperationsAsync(long id);
    Task<IReadOnlyList<SchScheduleResult>> GetByFactoryAndDateAsync(long factoryId, DateTime date);
    Task<SchScheduleResult?> GetLatestPublishedAsync(long factoryId);
}

/// <summary>
/// 物料库存仓储
/// </summary>
public interface IStockRepository : IRepository<InvMaterialStock>
{
    Task<InvMaterialStock?> GetByItemAndLotAsync(long itemId, string lotNo);
    Task<IReadOnlyList<InvMaterialStock>> GetByItemIdAsync(long itemId);
    Task<decimal> GetAvailableQtyAsync(long itemId, long? warehouseId = null);
}