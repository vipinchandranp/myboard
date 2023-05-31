import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myboard/models/my_board_user.dart';

class UserRepository {
  final String _apiUrl = 'https://your-backend-url.com/api/users';

  // Login
  Future<MyBoardUser> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/login'),
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return MyBoardUser.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to log in');
    }
  }

  // Signup
  Future<MyBoardUser> signUp(String email, String password, String name, String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/signup'),
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'name': name,
        'phoneNumber': phoneNumber,
      }),
    );

    if (response.statusCode == 201) {
      return MyBoardUser.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign up');
    }
  }

  // Fetch User
  Future<MyBoardUser> fetchUser(String id) async {
    final response = await http.get(
      Uri.parse('$_apiUrl/$id'),
    );

    if (response.statusCode == 200) {
      return MyBoardUser.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<MyBoardUser> authenticate(String username, String password) async {
    // Implement your authentication logic here
    // Connect to Azure and MongoDB to authenticate the user
    // Return the authenticated user if successful, otherwise throw an exception
    throw Exception('Authentication failed');
  }
}
