import 'package:dio/dio.dart';
import 'package:wife_gift/common/api/api_constants.dart';
import 'package:wife_gift/features/mood_screen/data/models/prefix.dart';

import 'prefix_data_source.dart';

class PrefixDataSourceImpl implements PrefixDataSource {
  final Dio _dio;

  PrefixDataSourceImpl(Dio dio) : _dio = dio;

  @override
  Future<List<Prefix>> getAll() async {
    final response = await _dio.get(ApiConstants.prefix);

    return (response.data as List)
        .map((json) => Prefix.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addRange(List<Prefix> prefixes) async {
    final data = prefixes.map((p) => p.toJson()).toList();

    await _dio.post(
      ApiConstants.prefix,
      data: data,
    );
  }
}