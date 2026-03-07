using Microsoft.EntityFrameworkCore;

namespace WifeGift.DataAccess.DbInitializiation
{
    public interface IDbInitializer<T>
    {
        void Initialize();
    }
}
