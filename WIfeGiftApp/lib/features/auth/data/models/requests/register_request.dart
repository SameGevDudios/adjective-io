import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable(createFactory: false)
class RegisterRequest {
  final String email;
  final String password;
  RegisterRequest({required this.email, required this.password});
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
