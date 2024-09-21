import 'package:json_annotation/json_annotation.dart';

part 'user_login_request.g.dart';

@JsonSerializable()
class UserLoginRequest {
  final String username;
  final String password;
  final String? email;
  final int? phone;

  UserLoginRequest({
    required this.username,
    required this.password,
    this.email,
    this.phone,
  });

  // Convert a JSON map to a UserLoginRequest instance
  factory UserLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$UserLoginRequestFromJson(json);

  // Convert a UserLoginRequest instance to a JSON map
  Map<String, dynamic> toJson() => _$UserLoginRequestToJson(this);
}
