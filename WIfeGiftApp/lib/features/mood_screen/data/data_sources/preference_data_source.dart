import 'package:wife_gift/features/mood_screen/data/models/preference.dart';

abstract class PreferenceDataSource {
  Future<List<Preference>> getAll();
  Future<void> addRange(List<Preference> preferences);
}