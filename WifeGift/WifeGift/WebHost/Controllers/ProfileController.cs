using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using WifeGift.Core.Services.ProfileService;
using static WifeGift.DataAccess.Models.Dto;

namespace WifeGift.WebHost.Controllers
{
    [Authorize]
    [Route("api/v1/profile")]
    public class ProfileController : BaseApiController
    {
        private readonly IUserDataService _userDataService;

        public ProfileController(IUserDataService userDataService)
        {
            _userDataService = userDataService;
        }

        [HttpPost("update")]
        public async Task<ActionResult<UserProfileDto>> Sync()
        {
            var userData = await _userDataService.UpdateProfileDataAsync(CurrentUserId);

            var response = new UserProfileDto(
                userData.Id,
                userData.UserId,
                userData.LastLoginAt,
                userData.Preferences?.Select(p => new PreferenceReadDto(p.Id, p.Adjective, p.Weight)).ToList() ?? new()
            );

            return Ok(response);
        }
    }
}
