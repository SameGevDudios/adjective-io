namespace WifeGift.DataAccess.Models
{
    public class Dto
    {
        public record PreferenceReadDto(Guid Id, string Adjective, double Weight);
        public record PreferenceCreateDto(string Adjective, double Weight);
        public record PreferenceUpdateDto(string Adjective, double Weight);

        public record UserDataReadDto(Guid Id, string UserId, List<PreferenceReadDto> Preferences);

        public record UserProfileDto(
            Guid Id,
            string UserId,
            DateTime LastLoginAt,
            List<PreferenceReadDto> Preferences);

        public record PrefixReadDto(Guid Id, string Title, string Subtitle);
        public record PrefixCreateDto(string Title, string Subtitle);
    }
}
