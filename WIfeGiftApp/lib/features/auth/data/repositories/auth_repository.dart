import 'package:wife_gift/features/auth/data/models/auth_dtos.dart';

abstract class AuthRepository {
  Future<void> login(LoginRequest request);
  Future<void> register(RegisterRequest request);
  Future<void> logout();
  Future<void> forgotPassword(String email);
  Future<bool> isAuthenticated();
}