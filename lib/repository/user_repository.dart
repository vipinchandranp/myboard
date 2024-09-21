import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../repository/base_repository.dart';
import '../api_models/user_signup_request.dart';
import '../api_models/user_login_request.dart';

class UserService extends BaseRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  UserService(BuildContext context) : super(context);

  Future<void> signup(UserSignupRequest userSignupRequest) async {
    final response = await client.post(
      Uri.parse('$apiUrl/user/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userSignupRequest.toJson()),
    );
  }

  Future<void> login(UserLoginRequest userLoginRequest) async {
    final response = await client.post(
      Uri.parse('$apiUrl/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userLoginRequest.toJson()),
    );
    final responseBody = jsonDecode(response.body);

    // Check if the response contains a JWT token and store it
    if (responseBody is Map<String, dynamic> &&
        responseBody.containsKey('data')) {
      final data = responseBody['data'] as Map<String, dynamic>;
      if (data.containsKey('jwtToken')) {
        final String newToken = data['jwtToken'];
        await _storage.write(key: 'jwtToken', value: newToken);
        print('New JWT token saved: $newToken');
      }
    }
  }

  Future<void> saveProfilePic(XFile image) async {
    final request =
    http.MultipartRequest('POST', Uri.parse('$apiUrl/user/profile-pic'))
      ..files.add(await http.MultipartFile.fromPath(
          'file', image.path)); // Ensure the part name is 'file'
    client.send(request);
  }

  Future<Image?> getProfilePic() async {
    final response = await client.get(Uri.parse('$apiUrl/user/profile-pic'));
    if (response.statusCode == 200) {
      if (response.headers['content-type']?.startsWith('image/') ?? false) {
        final Uint8List bytes = response.bodyBytes;
        return Image.memory(bytes); // Return the Image directly
      } else {
        throw Exception('Failed to load image: Content-Type is not an image');
      }
    } else {
      throw Exception('Failed to load image: ${response.statusCode}');
    }
  }
}
