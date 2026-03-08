namespace WifeGift.DataAccess.Models
{
    public class Prefix : BaseEntity
    {
        public required Guid UserDataId { get; set; }

        public required UserData UserData { get; set; }
        
        public required string Title { get; set; }

        public required string Subtitle { get; set; }
    }
}
