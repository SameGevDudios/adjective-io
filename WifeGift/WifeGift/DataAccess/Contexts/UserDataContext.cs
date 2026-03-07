using Microsoft.EntityFrameworkCore;
using WifeGift.DataAccess.Models;

namespace WifeGift.DataAccess.Contexts
{
    public class UserDataContext
    : DbContext
    {
        public UserDataContext(DbContextOptions<UserDataContext> options)
        : base(options) { }

        public DbSet<UserData> UserData { get; set; }
        public DbSet<Preference> Preferences { get; set; }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            builder.Entity<Preference>()
                .HasOne(p => p.UserData)
                .WithMany(u => u.Preferences)
                .HasForeignKey(p => p.UserDataId);
        }
    }
}
