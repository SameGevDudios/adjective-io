using WifeGift.DataAccess.Models;

namespace WifeGift.Core.Services.ProfileService
{
    public interface IUserDataService
    {
        Task<UserData> GetCurrentUserData(string userId);

        Task<UserData> UpdateProfileDataAsync(string userId);

        Task<IEnumerable<Preference>> GetUserPreferencesAsync(string userId);

        Task<bool> AddRangePreferenceAsync(string userId, IEnumerable<Preference> preferences);

        Task<bool> IncreasePreferenceWeightAsync(string userId, Guid preferenceId);

        Task<bool> DecreasePreferenceWeightAsync(string userId, Guid prefernceId);
    }
}
