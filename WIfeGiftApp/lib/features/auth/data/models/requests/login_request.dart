import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable(createFactory: false)
class LoginRequest {
  final String email;
  final String password;
  final String? twoFactorCode;
  final String? twoFactorRecoveryCode;

  LoginRequest({
    required this.email,
    required this.password,
    this.twoFactorCode,
    this.twoFactorRecoveryCode,
  });

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}