namespace WifeGift.DataAccess.Models
{
    public class UserData : BaseEntity
    {
        public required string UserId { get; set; }

        public required ICollection<Preference> Preferences { get; set; }

        public required ICollection<Prefix> Prefixes { get; set; }

        public DateTime LastLoginAt { get; set; } = DateTime.UtcNow;
    }
}
