using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using WifeGift.Core.Extensions;
using WifeGift.Core.Services.ProfileService;
using static WifeGift.DataAccess.Models.Dto;

namespace WifeGift.Controllers
{
    [Authorize]
    [Route("api/v1/preferences")]
    public class PreferencesController(IProfileService profileService) : BaseApiController
    {
        [HttpGet]
        public async Task<ActionResult<IEnumerable<PreferenceReadDto>>> GetAll()
        {
            var allPreferences = await profileService.GetUserPreferencesAsync(CurrentUserId);

            // Return only 70% of positive and 30% of negative adjectives
            var positivePreferences = allPreferences.Where(p => p.Weight >= 0).ToList();
            var negativePreferences = allPreferences.Where(p => p.Weight >= -1 && p.Weight < 0).ToList();

            int positiveCount = (int)Math.Ceiling(positivePreferences.Count * 0.7);
            int negativeCount = (int)Math.Ceiling(negativePreferences.Count * 0.3);

            var sampledPositive = positivePreferences.TakeRandom(positiveCount);
            var sampledNegative = negativePreferences.TakeRandom(negativeCount);

            var response = sampledPositive.Concat(sampledNegative)
                .Select(p => new PreferenceReadDto(p.Id, p.Adjective, p.Weight));

            return Ok(response);
        }

        [HttpPatch("{id:guid}/increment")]
        public async Task<IActionResult> IncrementWeight(Guid id) =>
            await profileService.IncreasePreferenceWeightAsync(CurrentUserId, id) ? Ok() : BadRequest();

        [HttpPatch("{id:guid}/decrement")]
        public async Task<IActionResult> Decrement(Guid id) =>
            await profileService.DecreasePreferenceWeightAsync(CurrentUserId, id) ? Ok() : BadRequest();
    }
}
