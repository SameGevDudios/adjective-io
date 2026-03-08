namespace WifeGift.Core.Extensions
{
    public static class EnumerableExtensions
    {
        public static IEnumerable<T> TakeRandom<T>(this IList<T> list, int count)
        {
            var rng = Random.Shared;
            int maxIndex = Math.Min(count, list.Count);

            for (int i = 0; i < maxIndex; i++)
            {
                int j = rng.Next(i, list.Count);
                (list[i], list[j]) = (list[j], list[i]);
                yield return list[i];
            }
        }
    }
}
