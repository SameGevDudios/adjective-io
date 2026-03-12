using WifeGift.Core.Configuration.PreferenceSettings;
using WifeGift.DataAccess.Models;
using WifeGift.DataAccess.Repositories;

namespace WifeGift.Core.Services.ProfileService
{
    public class UserDataService : IUserDataService
    {
        private readonly IRepository<UserData> _userRepository;

        private readonly IRepository<Preference> _preferenceRepository;

        private readonly IPreferenceSettings _settings;

        private readonly Random _random;

        public UserDataService(IRepository<UserData> userRepository, IRepository<Preference> preferenceRepository, IPreferenceSettings settings)
        {
            _userRepository = userRepository;
            _preferenceRepository = preferenceRepository;
            _settings = settings;
            _random = new Random();
        }

        public async Task<UserData> GetCurrentUserData(string userId)
        {   
            var userData = await _userRepository.GetByConditionAsync(u => u.UserId == userId);
            
            return userData;
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
                    Preferences = new List<Preference>(),
                    Prefixes = new List<Prefix>()
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
                    pref.Weight = Math.Max(0, pref.Weight - fadeValue);
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

            return preferences ?? Enumerable.Empty<Preference>();
        }

        public async Task<bool> AddRangePreferenceAsync(string userId, IEnumerable<Preference> preferences)
        {
            await _preferenceRepository.AddRangeAsync(preferences);

            return true;
        }

        public async Task<bool> IncreasePreferenceWeightAsync(string userId, Guid preferenceId)
        {
            var preference = await _preferenceRepository.GetByIdAsync(preferenceId);
            double randomDelta = _settings.MinDelta + _random.NextDouble() * (_settings.MaxDelta - _settings.MinDelta);
            double newWeight = preference.Weight + randomDelta;

            return await UpdatePreferenceWeightAsync(userId, preferenceId, newWeight);
        }

        public async Task<bool> DecreasePreferenceWeightAsync(string userId, Guid preferenceId)
        {
            var preference = await _preferenceRepository.GetByIdAsync(preferenceId);
            double randomDelta = _settings.MinDelta + _random.NextDouble() * (_settings.MaxDelta - _settings.MinDelta);
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

            // Buff or ban the entry
            if (Math.Abs(newWeight) > 1)
            {
                double edgeValue = _settings.WeightAbs;
                newWeight = Math.Clamp(newWeight *= edgeValue, -edgeValue, edgeValue);
            }

            pref.Weight = newWeight;
            await _preferenceRepository.UpdateAsync(pref);

            return true;
        }
    }
}