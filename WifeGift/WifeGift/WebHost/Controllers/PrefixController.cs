using Microsoft.AspNetCore.Mvc;
using WifeGift.DataAccess.Models;
using WifeGift.DataAccess.Repositories;
using static WifeGift.DataAccess.Models.Dto;

namespace WifeGift.WebHost.Controllers
{
    public class PrefixController : BaseApiController
    {
        private readonly IRepository<UserData> _userRepository;
        private readonly IRepository<Prefix> _prefixRepository;

        public PrefixController(IRepository<UserData> userRepository, IRepository<Prefix> prefixRepository)
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

            if(userData == null) return NotFound("User not found.");

            var prefixes = prefixDtos.Select(p => new Prefix
            {
                Id = Guid.NewGuid(),
                UserDataId = userData.Id,
                UserData = userData,
                Title = p.Title,
                Subtitle = p.Subtitle
            }).ToList();

            await _prefixRepository.AddRangeAsync(prefixes);

            return Ok(prefixes);
        }
    }
}
