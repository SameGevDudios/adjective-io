using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using WifeGift.DataAccess.Models;
using WifeGift.DataAccess.Repositories;
using static WifeGift.DataAccess.Models.Dto;

namespace WifeGift.WebHost.Controllers
{
<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
    [Authorize]
    [Route("api/v1/prefixes")]
    public class PrefixesController : BaseApiController
    {
        private readonly IRepository<UserData> _userRepository;
        private readonly IRepository<Prefix> _prefixRepository;

        public PrefixesController(IRepository<UserData> userRepository, IRepository<Prefix> prefixRepository)
        {
            _userRepository = userRepository;
            _prefixRepository = prefixRepository;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<PrefixReadDto>>> GetAll()
        {
            var userData = await _userRepository.GetByConditionAsync(u => u.UserId == CurrentUserId);
            
            if (userData == null) return NotFound("User not found.");

            var prefixes = await _prefixRepository.GetListByConditionAsync(p => p.UserDataId == userData.Id);
            var prefixDtos = prefixes.Select(p => new PrefixReadDto(p.Id, p.Title, p.Subtitle)).ToList();

            return prefixDtos;
        }

        [HttpPost]
        public async Task<IActionResult> AddRange([FromBody] List<PrefixCreateDto> prefixDtos)
        {
            var userData = await _userRepository.GetByConditionAsync(u => u.UserId == CurrentUserId);

<<<<<<< Updated upstream
            if(userData == null) return NotFound("User not found.");

=======
            if (userData == null) return NotFound("User not found.");

>>>>>>> Stashed changes
            var prefixes = prefixDtos.Select(p => new Prefix
            {
                Id = Guid.NewGuid(),
                UserDataId = userData.Id,
<<<<<<< Updated upstream
                UserData = userData,
=======
>>>>>>> Stashed changes
                Title = p.Title,
                Subtitle = p.Subtitle
            }).ToList();

            await _prefixRepository.AddRangeAsync(prefixes);

<<<<<<< Updated upstream
            return Ok(prefixes);
=======
            var response = prefixes.Select(p => new PrefixReadDto(
                p.Id,
                p.Title,
                p.Subtitle
            )).ToList();

            return Ok(response);
>>>>>>> Stashed changes
        }
    }
}
