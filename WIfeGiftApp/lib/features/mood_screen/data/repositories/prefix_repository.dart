import 'package:wife_gift/features/mood_screen/data/models/prefix.dart';

abstract class PrefixRepository {
  Future<List<Prefix>> getAllPrefixes();
  Future<void> addPrefixes(List<Prefix> prefixes);
}