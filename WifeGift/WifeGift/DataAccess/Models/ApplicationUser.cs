using Microsoft.AspNetCore.Identity;

namespace WifeGift.DataAccess.Models
{
    public class ApplicationUser : IdentityUser
    {
        public required virtual UserData UserData { get; set; }
    }
}
