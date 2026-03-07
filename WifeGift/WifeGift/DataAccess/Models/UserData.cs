namespace WifeGift.DataAccess.Models
{
    public class UserData : BaseEntity
    {
        public required string UserId { get; set; }

        public required ApplicationUser User { get; set; }

        public required ICollection<Preference> Preferences { get; set; }
    }
}
