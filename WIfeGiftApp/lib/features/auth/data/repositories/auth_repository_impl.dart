import 'package:dio/dio.dart';
import 'package:wife_gift/common/exceptions/failure.dart';
import 'package:wife_gift/common/storage/token_storage.dart';
import 'package:wife_gift/features/auth/data/data_sources/auth_data_source.dart';
import 'package:wife_gift/features/auth/data/models/auth_dtos.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._tokenStorage);

  @override
  Future<void> login(String email, String password) async {
    try {
      final response = await _remoteDataSource.login(
        LoginRequest(email: email, password: password),
      );
      await _tokenStorage.saveTokens(
        access: response.accessToken,
        refresh: response.refreshToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> register(String email, String password) async {
    try {
      await _remoteDataSource.register(RegisterRequest(email: email, password: password));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _tokenStorage.getAccessToken();
    return token != null;
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _remoteDataSource.forgotPassword(ForgotPasswordRequest(email: email));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Failure _handleError(DioException e) {
    if (e.response?.statusCode == 400) {
      final data = e.response?.data;
      return ValidationFailure(
        message: data['title'] ?? 'Ошибка валидации',
        errors: (data['errors'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, List<String>.from(value)),
        ) ?? {},
      );
    }
    return ServerFailure(e.message ?? 'Произошла системная ошибка');
  }
}