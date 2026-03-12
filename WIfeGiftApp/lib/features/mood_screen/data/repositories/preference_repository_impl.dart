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
      return await _dataSource.getAll();
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

  @override
  Future<void> incrementWeight(String id) async {
    try {
      await _dataSource.increment(id);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> decrementWeight(String id) async {
    try {
      await _dataSource.decrement(id);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Failure _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
      return NetworkFailure('No server connection');
    }
    return ServerFailure(e.message ?? 'Server error occurred');
  }
}