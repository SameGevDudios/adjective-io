import 'package:wife_gift/features/mood_screen/data/models/preference.dart';

abstract class PreferenceRepository {
  Future<List<Preference>> getAllPreferences();
  Future<void> addPreferences(List<Preference> preferences);
  Future<void> incrementWeight(String id);
  Future<void> decrementWeight(String id);
}