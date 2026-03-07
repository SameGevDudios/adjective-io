namespace WifeGift.DataAccess.Models
{
    public class UserData : BaseEntity
    {
        public string UserId { get; set; }

        public ApplicationUser User { get; set; }

        public ICollection<Preference> Preferences { get; set; }
    }
}
