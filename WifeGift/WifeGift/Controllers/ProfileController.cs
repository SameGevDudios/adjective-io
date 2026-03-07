using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using WifeGift.Services.ProfileService;
using static WifeGift.DataAccess.Models.Dto;

namespace WifeGift.Controllers
{
    [Authorize]
    [Route("api/v1/profile")]
    public class ProfileController : BaseApiController
    {
        private readonly IProfileService _profileService;

        public ProfileController(IProfileService profileService)
        {
            _profileService = profileService;
        }

        [HttpPost("update")]
        public async Task<ActionResult<UserProfileDto>> Sync()
        {
            var userData = await _profileService.UpdateProfileDataAsync(CurrentUserId);

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
