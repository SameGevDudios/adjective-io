using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using WifeGift.Core.Configuration.PreferenceSettings;
using WifeGift.Core.Extensions;
using WifeGift.Core.Services.ProfileService;
using WifeGift.DataAccess.Models;
using static WifeGift.DataAccess.Models.Dto;

namespace WifeGift.WebHost.Controllers
{
    [Authorize]
    [Route("api/v1/preferences")]
    public class PreferencesController : BaseApiController
    {
        private readonly IUserDataService _userDataService;
        private readonly IPreferenceSettings _settings;

        public PreferencesController(IUserDataService userDataService, IPreferenceSettings settings)
        {
            _userDataService = userDataService;
            _settings = settings;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<PreferenceReadDto>>> GetAll()
        {
            var allPreferences = await _userDataService.GetUserPreferencesAsync(CurrentUserId);

            var positivePreferences = allPreferences.Where(p => p.Weight >= 0).ToList();
            var negativePreferences = allPreferences.Where(p => p.Weight >= -1 && p.Weight < 0).ToList();

            int positiveCount = (int)Math.Ceiling(positivePreferences.Count * _settings.PositivePercentage);
            int negativeCount = (int)Math.Ceiling(negativePreferences.Count * _settings.NegativePercentage);

            var sampledPositive = positivePreferences.TakeRandom(positiveCount);
            var sampledNegative = negativePreferences.TakeRandom(negativeCount);

            var response = sampledPositive.Concat(sampledNegative)
                .Select(p => new PreferenceReadDto(p.Id, p.Adjective, p.Weight));

            return Ok(response);
        }

        [HttpPost()]
        public async Task<IActionResult> AddRange([FromBody] List<PreferenceCreateDto> dtos)
        {
            var userData = await _userDataService.GetCurrentUserData(CurrentUserId);

            var preferences = dtos.Select(dto => new Preference
            {
                Id = Guid.NewGuid(),
                UserDataId = userData.Id,
                Adjective = dto.Adjective,
                Weight = dto.Weight,
            }).ToList();

            await _userDataService.AddRangePreferenceAsync(CurrentUserId, preferences);

            return Ok(preferences);
        }

        [HttpPatch("{id:guid}/increment")]
        public async Task<IActionResult> IncrementWeight(Guid id) =>
            await _userDataService.IncreasePreferenceWeightAsync(CurrentUserId, id) ? Ok() : BadRequest();

        [HttpPatch("{id:guid}/decrement")]
        public async Task<IActionResult> Decrement(Guid id) =>
            await _userDataService.DecreasePreferenceWeightAsync(CurrentUserId, id) ? Ok() : BadRequest();
    }
}
