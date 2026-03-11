import 'package:dio/dio.dart';
import 'package:wife_gift/common/exceptions/failure.dart';
import 'package:wife_gift/features/mood_screen/data/data_sources/preference_data_source.dart';
import 'package:wife_gift/features/mood_screen/data/models/preference.dart';
import 'package:wife_gift/features/mood_screen/data/repositories/preference_repository.dart';

class PreferenceRepositoryImpl extends PreferenceRepository {
  final PreferenceDataSource _dataSource;

  PreferenceRepositoryImpl(PreferenceDataSource dataSource) : _dataSource = dataSource;

  @override
  Future<List<Preference>> getAllPreferences() async {
    try {
      final preferences = await _dataSource.getAll();

      return preferences;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> addPreferences(List<Preference> preferences) async {
    try {
      await _dataSource.addRange(preferences);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Failure _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return NetworkFailure('No server connection');
    }

    if (e.response?.statusCode == 400) {
      return ValidationFailure(
        message: e.response?.data['title'] ?? 'Validation error',
        errors: {},
      );
    }

    return ServerFailure(e.message ?? 'Server error occurred');
  }
}
