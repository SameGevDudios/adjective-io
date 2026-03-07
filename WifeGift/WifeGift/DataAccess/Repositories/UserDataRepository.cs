using Microsoft.EntityFrameworkCore;
using WifeGift.DataAccess.Contexts;
using WifeGift.DataAccess.Models;

namespace WifeGift.DataAccess.Repositories
{
    public class UserDataRepository<T> : IRepository<T> where T : BaseEntity
    {
        private readonly UserDataContext _dbContext;

        public UserDataRepository(UserDataContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<IEnumerable<T>> GetAllAsync()
        {
            var entities = await _dbContext.Set<T>().ToListAsync();

            return entities;
        }

        public async Task<T> GetByIdAsync(Guid id)
        {
            var entity = await _dbContext.Set<T>().FirstOrDefaultAsync(x => x.Id == id);

            return entity;
        }

        public async Task<IEnumerable<T>> GetRangeByIdsAsync(List<Guid> ids)
        {
            var entities = await _dbContext.Set<T>().Where(x => ids.Contains(x.Id)).ToListAsync();

            return entities;
        }

        public async Task AddAsync(T entity)
        {
            await _dbContext.Set<T>().AddAsync(entity);

            await _dbContext.SaveChangesAsync();
        }

        public async Task UpdateAsync(T entity)
        {
            _dbContext.Set<T>().Update(entity);

            await _dbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(T entity)
        {
            _dbContext.Set<T>().Remove(entity);

            await _dbContext.SaveChangesAsync();
        }
    }
}
