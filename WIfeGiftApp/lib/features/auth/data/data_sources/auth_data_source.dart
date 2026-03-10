import 'package:dio/dio.dart';
import 'package:wife_gift/common/api/api_constants.dart';
import 'package:wife_gift/features/auth/data/models/auth_dtos.dart';

abstract class AuthDataSource {
  Future<void> register(RegisterRequest request);
  Future<AccessTokenResponse> login(LoginRequest request);
  Future<void> forgotPassword(ForgotPasswordRequest request);
  Future<void> resetPassword(ResetPasswordRequest request);
}

class AuthDataSourceImpl implements AuthDataSource {
  final Dio _dio;

  AuthDataSourceImpl(Dio dio) : _dio = dio;

  @override
  Future<void> register(RegisterRequest request) async {
    await _dio.post(ApiConstants.register, data: request.toJson());
  }

  @override
  Future<AccessTokenResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: request.toJson(),
      // Пример передачи query параметров из Swagger
      queryParameters: {'useCookies': false},
    );
    return AccessTokenResponse.fromJson(response.data);
  }

  @override
  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    await _dio.post(ApiConstants.forgotPassword, data: request.toJson());
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    await _dio.post(ApiConstants.resetPassword, data: request.toJson());
  }
}
