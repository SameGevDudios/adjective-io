namespace WifeGift.DataAccess.Models
{
    public class Preference : BaseEntity
    {
        public Guid UserDataId { get; set; }

        public UserData UserData { get; set; }

        public required string Adjective { get; set; }

        public double Weight { get; set; }
    }
}
