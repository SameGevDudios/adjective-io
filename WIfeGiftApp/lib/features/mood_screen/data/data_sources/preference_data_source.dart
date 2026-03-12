import 'package:wife_gift/features/mood_screen/data/models/preference.dart';

abstract class PreferenceDataSource {
  Future<List<Preference>> getAll();
  Future<List<Preference>> getSampled();
  Future<void> addRange(List<Preference> preferences);
  Future<void> increment(String id);
  Future<void> decrement(String id);
}