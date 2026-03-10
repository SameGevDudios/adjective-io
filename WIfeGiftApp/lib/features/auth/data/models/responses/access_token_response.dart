import 'package:json_annotation/json_annotation.dart';

part 'access_token_response.g.dart';

@JsonSerializable(createToJson: false)
class AccessTokenResponse {
  final String tokenType;
  final String accessToken;
  final int expiresIn;
  final String refreshToken;

  AccessTokenResponse({
    required this.tokenType,
    required this.accessToken,
    required this.expiresIn,
    required this.refreshToken,
  });

  factory AccessTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenResponseFromJson(json);
}