import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myboard/config/api_config.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/models/login_response.dart';

class UserRepository {
  final String _apiUrl = APIConfig.getRootURL();

  // Login
  Future<LoginResponse> signIn(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/v1/users/login'),
      headers: {'Content-Type': 'application/json'},
      // Set the Content-Type header
      body: jsonEncode(<String, String>{
        'password': password,
        'username': username,
      }),
    );

    if (response.statusCode == 200) {
      final loginResponse = LoginResponse.fromMap(jsonDecode(response.body));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', loginResponse.token);
      return loginResponse;
    } else {
      throw Exception('Failed to log in');
    }
  }

  // Signup
  Future<MyBoardUser> signUp(String email, String password, String name) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/signup'),
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'name': name,
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
