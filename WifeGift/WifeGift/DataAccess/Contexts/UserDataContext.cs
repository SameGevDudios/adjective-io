using Microsoft.EntityFrameworkCore;
using WifeGift.DataAccess.Models;

namespace WifeGift.DataAccess.Contexts
{
    public class UserDataContext : DbContext
    {
        public UserDataContext(DbContextOptions<UserDataContext> options)
        : base(options) { }

        public DbSet<UserData> UserData { get; set; }
        public DbSet<Preference> Preferences { get; set; }
        public DbSet<Prefix> Prefixes { get; set; }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            builder.Entity<Preference>()
                .HasOne(p => p.UserData)
                .WithMany(u => u.Preferences)
                .HasForeignKey(p => p.UserDataId)
                .OnDelete(DeleteBehavior.Cascade);

            builder.Entity<Prefix>()
                .HasOne(px => px.UserData)
                .WithMany(u => u.Prefixes)
                .HasForeignKey(px => px.UserDataId)
                .OnDelete(DeleteBehavior.Cascade);

            builder.Entity<UserData>()
                .HasIndex(u => u.UserId)
                .IsUnique();
        }
    }
}
