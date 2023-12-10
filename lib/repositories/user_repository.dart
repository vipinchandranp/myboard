import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myboard/config/api_config.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/models/login_response.dart';

class UserRepository {
  final String _apiUrl = APIConfig.getRootURL();

  Future<String> signIn(String username, String password) async {
    final response = await http.get(
      Uri.parse(APIConfig.getRootURL() +
          '/v1/users/login?username=$username&password=$password'),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    // Log headers for debugging
    print('Response Headers: ${response.headers['Authorization']}');

    // Check if the response is from an OPTIONS request
    if (response.statusCode == 200 && response.request?.method != 'OPTIONS') {
      // Save the token to shared_preferences
      // Decode the JSON response to extract the token
      final jsonResponse = json.decode(response.body);

      // Extract the token from the decoded JSON response
      final token = jsonResponse['token'];

      await saveTokenToSharedPreferences(token);

      return "LoggedIn successfully";
    } else {
      throw Exception('Failed to log in');
    }
  }

  Future<void> saveTokenToSharedPreferences(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<List<String>> getAvailableUsers(String pattern) async {
    try {
      if (pattern == null) throw Exception('No Authenticated user found');
      final response =
          await http.get(Uri.parse('$_apiUrl/v1/users/${pattern}'));
      if (response.statusCode == 200) {
        List<dynamic> tempUserList = jsonDecode(response.body);
        List<String> stringList = tempUserList.cast<String>();
        return stringList;
      } else {
        // Handle error case
        return [];
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to fetch users');
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
      throw Exception('Signedup successfully');
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
