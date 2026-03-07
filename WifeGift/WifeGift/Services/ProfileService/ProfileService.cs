using WifeGift.DataAccess.Models;
using WifeGift.DataAccess.Repositories;

namespace WifeGift.Services.ProfileService
{
    public class ProfileService : IProfileService
    {
        private readonly IRepository<UserData> _userRepository;

        private readonly IRepository<Preference> _preferenceRepository;

        private readonly Random _random;

        public ProfileService(IRepository<UserData> userRepository, IRepository<Preference> preferenceRepository)
        {
            _userRepository = userRepository;
            _preferenceRepository = preferenceRepository;
            _random = new Random();
        }

        public async Task<UserData> UpdateProfileDataAsync(string userId)
        {
            var userData = await _userRepository.GetByConditionAsync(u => u.UserId == userId);

            // Create user data if user is new
            if (userData == null)
            {
                userData = new UserData
                {
                    Id = Guid.NewGuid(),
                    UserId = userId,
                    LastLoginAt = DateTime.UtcNow,
                    Preferences = new List<Preference>()
                };
                await _userRepository.AddAsync(userData);
                return userData;
            }

            // Adjective weight fade
            var now = DateTime.UtcNow;
            var daysPassed = (now.Date - userData.LastLoginAt.Date).Days;

            if (daysPassed >= 1)
            {
                var userPrefs = await _preferenceRepository.GetListByConditionAsync(p => p.UserDataId == userData.Id);

                double fadeValue = daysPassed * 0.05;

                foreach (var pref in userPrefs)
                {
                    pref.Weight = Math.Max(-1.5, pref.Weight - fadeValue); // TODO: move max value '-1.5' to a configuration file
                }

                userData.LastLoginAt = now;
                userData.Preferences = userPrefs.ToList();

                await _userRepository.UpdateAsync(userData);
            }

            return userData;
        }

        public async Task<IEnumerable<Preference>> GetUserPreferencesAsync(string userId)
        {
            var userData = await _userRepository.GetByConditionAsync(u => u.UserId == userId);

            if (userData == null) return Enumerable.Empty<Preference>();

            var preferences = await _preferenceRepository.GetListByConditionAsync(p => p.UserDataId == userData.Id);

            return userData.Preferences;
        }

        public async Task<bool> IncreasePreferenceWeightAsync(string userId, Guid preferenceId)
        {
            var preference = await _preferenceRepository.GetByIdAsync(preferenceId);
            double randomDelta = 0.2 + _random.NextDouble() * (0.35 - 0.2); // TODO: move min and max values to a configuration file
            double newWeight = preference.Weight + randomDelta;

            return await UpdatePreferenceWeightAsync(userId, preferenceId, newWeight);
        }

        public async Task<bool> DecreasePreferenceWeightAsync(string userId, Guid preferenceId)
        {
            var preference = await _preferenceRepository.GetByIdAsync(preferenceId);
            double randomDelta = 0.2 + _random.NextDouble() * (0.35 - 0.2); // TODO: move min and max values to a configuration file
            double newWeight = preference.Weight - randomDelta;

            return await UpdatePreferenceWeightAsync(userId, preferenceId, newWeight);
        }

        private async Task<bool> UpdatePreferenceWeightAsync(string userId, Guid preferenceId, double newWeight)
        {
            var pref = await _preferenceRepository.GetByIdAsync(preferenceId);
            if (pref == null) return false;

            // Check entry access
            var userData = await _userRepository.GetByConditionAsync(u => u.UserId == userId);

            if (userData == null || pref.UserDataId != userData.Id)
                return false;

            pref.Weight = newWeight;
            await _preferenceRepository.UpdateAsync(pref);
            return true;
        }
    }
}