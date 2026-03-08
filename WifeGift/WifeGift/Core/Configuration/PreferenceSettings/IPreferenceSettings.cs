namespace WifeGift.Core.Configuration.PreferenceSettings
{
    public interface IPreferenceSettings
    {
        double MinDelta { get; }
        double MaxDelta { get; }
        double FadeRate { get; }
        double WeightAbs { get; }
        double PositivePercentage { get; }
        double NegativePercentage { get; }
    }
}
