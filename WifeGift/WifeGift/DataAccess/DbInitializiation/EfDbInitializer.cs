using Microsoft.EntityFrameworkCore;

namespace WifeGift.DataAccess.DbInitializiation
{
    public class EfDbInitializer<T> : IDbInitializer<T> where T : ICollection<DbContext>
    {
        private readonly T _dbContexts;

        public EfDbInitializer(T dbContext)
        {
            _dbContexts = dbContext;
        }

        public void Initialize()
        {
            foreach (var dbContext in _dbContexts)
            {
                dbContext.Database.EnsureCreated();
            }
        }
    }
}
