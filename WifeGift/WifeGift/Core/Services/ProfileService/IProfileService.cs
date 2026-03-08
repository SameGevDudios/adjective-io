using WifeGift.DataAccess.Models;

namespace WifeGift.Core.Services.ProfileService
{
    public interface IProfileService
    {
        Task<UserData> UpdateProfileDataAsync(string userId);

        Task<IEnumerable<Preference>> GetUserPreferencesAsync(string userId);

        Task<bool> IncreasePreferenceWeightAsync(string userId, Guid preferenceId);

        Task<bool> DecreasePreferenceWeightAsync(string userId, Guid prefernceId);
    }
}
