namespace WifeGift.DataAccess.Models
{
    public class Preference : BaseEntity
    {
        public Guid UserDataId { get; set; }

        required public UserData UserData { get; set; }

        required public string Adjective { get; set; }

        public double Weight { get; set; }
    }
}
