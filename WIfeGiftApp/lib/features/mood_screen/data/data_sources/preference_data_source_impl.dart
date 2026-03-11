import 'package:dio/dio.dart';
import 'package:wife_gift/common/api/api_constants.dart';
import 'package:wife_gift/features/mood_screen/data/data_sources/preference_data_source.dart';
import 'package:wife_gift/features/mood_screen/data/models/preference.dart';

class PreferenceDataSourceImpl extends PreferenceDataSource {
  final Dio _dio;

  PreferenceDataSourceImpl(Dio dio) : _dio = dio;

  @override
  Future<List<Preference>> getAll() async {
    final response = await _dio.get(ApiConstants.preferences);

    return (response.data as List)
        .map((json) => Preference.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addRange(List<Preference> preferences) async {
    final data = preferences.map((p) => p.toJson()).toList();

    await _dio.post(ApiConstants.preferences, data: data);
  }
}
