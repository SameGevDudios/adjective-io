import 'package:wife_gift/features/mood_screen/data/models/prefix.dart';

abstract class PrefixDataSource {
  Future<List<Prefix>> getAll();

  Future<void> addRange(List<Prefix> prefixes);
}