
import 'package:wife_gift/features/auth/data/models/auth_dtos.dart';

abstract class AuthDataSource {
  Future<void> register(RegisterRequest request);
  Future<AccessTokenResponse> login(LoginRequest request);
  Future<void> forgotPassword(ForgotPasswordRequest request);
  Future<void> resetPassword(ResetPasswordRequest request);
}
