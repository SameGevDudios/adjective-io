namespace WifeGift.Core.Configuration.PreferenceSettings
{
    public class PreferenceSettings : IPreferenceSettings
    {
        public double MinDelta { get; set; }
        public double MaxDelta { get; set; }
        public double FadeRate { get; set; }
        public double WeightAbs { get; set; }
        public double WeightMultiplier { get; set; }
        public double PositivePercentage { get; set; }
        public double NegativePercentage { get; set; }
    }
}