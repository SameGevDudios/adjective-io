import 'package:dio/dio.dart';
import 'package:wife_gift/common/exceptions/failure.dart';
import 'package:wife_gift/features/mood_screen/data/data_sources/prefix_data_source.dart';
import 'package:wife_gift/features/mood_screen/data/models/prefix.dart';

import 'prefix_repository.dart';

class PrefixRepositoryImpl implements PrefixRepository {
  final PrefixDataSource _dataSource;

  PrefixRepositoryImpl(PrefixDataSource dataSource) : _dataSource = dataSource;

  @override
  Future<List<Prefix>> getAllPrefixes() async {
    try {
      final prefixes = await _dataSource.getAll();

      return prefixes;

    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> addPrefixes(List<Prefix> prefixes) async {
    try {
      await _dataSource.addRange(prefixes);
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
        errors: {}
      );
    }

    return ServerFailure(e.message ?? 'Server error occurred');
  }
}