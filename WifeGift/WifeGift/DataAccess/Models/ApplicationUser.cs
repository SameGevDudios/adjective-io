using Microsoft.AspNetCore.Identity;

namespace WifeGift.DataAccess.Models
{
    public class ApplicationUser : IdentityUser
    {
        public virtual UserData UserData { get; set; }
    }
}
