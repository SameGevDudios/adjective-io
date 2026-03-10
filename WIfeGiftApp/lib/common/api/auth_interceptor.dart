import 'package:dio/dio.dart';
import 'package:wife_gift/common/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _refreshDio;

  AuthInterceptor(TokenStorage tokenStorage, String baseUrl)
    : _tokenStorage = tokenStorage,
      _refreshDio = Dio(BaseOptions(baseUrl: baseUrl));

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await _tokenStorage.getRefreshToken();

      if (refreshToken != null) {
        try {
          final response = await _refreshDio.post(
            '/api/v1/refresh',
            data: {'refreshToken': refreshToken},
          );

          final newAccess = response.data['accessToken'];
          final newRefresh = response.data['refreshToken'];

          await _tokenStorage.saveTokens(access: newAccess, refresh: newRefresh);

          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newAccess';

          final clonedRequest = await _refreshDio.request(
            opts.path,
            options: Options(method: opts.method, headers: opts.headers),
            data: opts.data,
            queryParameters: opts.queryParameters,
          );

          return handler.resolve(clonedRequest);
        } catch (e) {
          await _tokenStorage.clearTokens();
        }
      }
    }
    return handler.next(err);
  }
}
