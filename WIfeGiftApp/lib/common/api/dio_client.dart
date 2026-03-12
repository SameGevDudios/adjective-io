import 'package:dio/dio.dart';
import 'package:wife_gift/common/config/env_config.dart';
import 'api_constants.dart';
import 'auth_interceptor.dart';

class DioClient {
  final Dio dio;

  DioClient(AuthInterceptor authInterceptor)
    : dio = Dio(
        BaseOptions(
          baseUrl: EnvConfig.baseUrl,
          connectTimeout: ApiConstants.connectTimeout,
          receiveTimeout: ApiConstants.receiveTimeout,
          contentType: 'application/json',
        ),
      ) {
    dio.interceptors.add(authInterceptor);

    if (EnvConfig.isDebug) {
      dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    }
  }
}
