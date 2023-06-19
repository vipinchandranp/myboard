import 'package:myboard/models/user.dart';

class LoginResponse {
  final String token;
  final MyBoardUser user;

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      token: map['token'],
      user: MyBoardUser.fromMap(map['user']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'user': user.toMap(),
    };
  }
}
