using System.Linq.Expressions;

namespace WifeGift.DataAccess.Repositories
{
    public interface IRepository<T>
    {
        Task<IEnumerable<T>> GetAllAsync();

        Task<T> GetByIdAsync(Guid id);

        Task<IEnumerable<T>> GetRangeByIdsAsync(List<Guid> ids);

        Task AddAsync(T entity);

        Task AddRangeAsync(IEnumerable<T> entities);

        Task UpdateAsync(T entity);

        Task DeleteAsync(T entity); 
        
        Task<T?> GetByConditionAsync(Expression<Func<T, bool>> predicate);

        Task<IEnumerable<T>> GetListByConditionAsync(Expression<Func<T, bool>> predicate);
    }
}
