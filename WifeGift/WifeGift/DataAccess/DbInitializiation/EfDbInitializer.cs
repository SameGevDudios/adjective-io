using Microsoft.EntityFrameworkCore;

namespace WifeGift.DataAccess.DbInitializiation
{
    public class EfDbInitializer : IDbInitializer
    {
        private readonly ICollection<DbContext> _dbContexts;

        public EfDbInitializer(ICollection<DbContext> dbContext)
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
