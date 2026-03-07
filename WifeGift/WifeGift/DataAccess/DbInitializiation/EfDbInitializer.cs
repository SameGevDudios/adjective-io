using Microsoft.EntityFrameworkCore;
using WifeGift.DataAccess.Contexts;

namespace WifeGift.DataAccess.DbInitializiation
{
    public class EfDbInitializer : IDbInitializer
    {
        private readonly AuthContext _authContext;
        private readonly UserDataContext _userDataContext;

        public EfDbInitializer(AuthContext authContext, UserDataContext userDataContext)
        {
            _authContext = authContext;
            _userDataContext = userDataContext;
        }

        public void Initialize()
        {
            _authContext.Database.EnsureCreated();
            _userDataContext.Database.EnsureCreated();
        }
    }
}
