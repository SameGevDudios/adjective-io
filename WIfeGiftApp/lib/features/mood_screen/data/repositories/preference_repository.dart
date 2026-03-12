import 'package:wife_gift/features/mood_screen/data/models/preference.dart';

abstract class PreferenceRepository {
  Future<List<Preference>> getAll();
  Future<List<Preference>> getSampledPreferences();
  Future<void> addPreferences(List<Preference> preferences);
  Future<void> incrementWeight(String id);
  Future<void> decrementWeight(String id);
}