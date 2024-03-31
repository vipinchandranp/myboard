import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myboard/config/api_config.dart';
import 'package:myboard/models/UserProfile.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/models/location_search.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/common-util/common_util_token_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/location.dart';

class UserRepository {
  final String _apiUrl = APIConfig.getRootURL();
  final GetIt getIt = GetIt.instance;

  Future<String> signIn(String username, String password) async {
    final response = await http.get(
      Uri.parse(APIConfig.getRootURL() +
          '/v1/users/login?username=$username&password=$password'),
      headers: {'Content-Type': 'application/json'},
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

  Future<void> saveDisplay(
    BuildContext context,
    DisplayDetails displayDetails,
  ) async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
          getIt<TokenInterceptorHttpClient>();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_apiUrl/v1/displays/save'),
      );

      // Add display details as fields
      request.fields['displayName'] = displayDetails.displayName;
      request.fields['description'] = displayDetails.description!;
      request.fields['latitude'] = displayDetails.latitude.toString();
      request.fields['longitude'] = displayDetails.longitude.toString();

      // Add image files if available
      await addImageFilesToRequest(request, displayDetails.images);

      final response = await tokenInterceptor.send(request);

      if (response.statusCode == 200) {
        // Display saved successfully
        print('Display saved successfully');
        // You can use 'context' for any UI-related operations here if needed
      } else {
        // Handle error case
        print(
            'Failed to save display. Server returned status code: ${response.statusCode}');
        throw Exception('Failed to save display');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to save display');
    }
  }

  Future<void> addImageFilesToRequest(
    http.MultipartRequest request,
    List<XFile>? imageFiles,
  ) async {
    if (imageFiles != null && imageFiles.isNotEmpty) {
      for (var imageFile in imageFiles) {
        // Add each image file to the request using the helper function
        await addImageFileToRequest(request, imageFile);
      }
    }
  }

  Future<void> addImageFileToRequest(
    http.MultipartRequest request,
    XFile? imageFile,
  ) async {
    if (imageFile != null) {
      try {
        // Check if the app is running in a web environment
        if (kIsWeb) {
          // Use fromBytes for web environments
          List<int> imageBytes = await imageFile.readAsBytes();
          var imagePart = http.MultipartFile.fromBytes(
            'imageFile',
            imageBytes,
            filename: imageFile.path.replaceAll(' ', '_') + '.jpg',
            contentType: MediaType('application', 'octet-stream'),
          );

          request.files.add(imagePart);
        } else {
          // Use fromPath for non-web environments
          var imagePart = await http.MultipartFile.fromPath(
            'imageFiles',
            imageFile.path,
            filename: imageFile.path.replaceAll(' ', '_') + '.jpg',
          );
          request.files.add(imagePart);
        }
      } catch (e) {
        print('Error adding image file to request: $e');
        // Handle the error appropriately
        throw Exception('Failed to add image file to the request');
      }
    }
  }

  Future<void> deleteDisplay(BuildContext context, String displayId) async {
    try {
      // Implement the logic to delete the display with the given displayId
      // This might involve sending a DELETE request to your backend server

      // Assuming successful deletion, print a message
      print('Display deleted successfully');
      // You can use 'context' for any UI-related operations here if needed
    } catch (e) {
      // Handle error case
      print('Failed to delete display');
      throw Exception('Failed to delete display');
    }
  }

  Future<void> saveLocation(SelectLocationDTO location) async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
          getIt<TokenInterceptorHttpClient>();
      final response = await tokenInterceptor.post(
        Uri.parse('$_apiUrl/v1/users/save-location'),
        body: jsonEncode(location.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Location saved successfully
        print('Location saved successfully');
      } else {
        // Handle error case
        print(
            'Failed to save location. Server returned status code: ${response.statusCode}');
        throw Exception('Failed to save location');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to save location');
    }
  }

  Future<MyBoardUser> initUser() async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
          getIt<TokenInterceptorHttpClient>();
      final response = await tokenInterceptor.get(
        Uri.parse('$_apiUrl/v1/users/init-user'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> userData = json.decode(response.body);

        // Extract the selectedLocation value as a Map
        Map<String, dynamic>? selectedLocationData =
            userData['selectedLocation'];

        // Assuming Location has a toMap method
        Location location = Location(
          name: selectedLocationData?['name'] ?? '',
          latitude: selectedLocationData?['latitude'] ?? 0.0,
          longitude: selectedLocationData?['longitude'] ?? 0.0,
        );

// Create a MyBoardUser object with the parsed data
        MyBoardUser user = MyBoardUser.fromMap({
          'id': '',
          'username': userData['username'],
          'location': location.toMap(), // Convert Location to a map
        });

        return user;
      } else {
        // Handle error case
        print(
            'Failed to fetch user data. Server returned status code: ${response.statusCode}');
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to fetch user data');
    }
  }

  Future<void> saveUserProfile(UserProfile userProfile) async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
          getIt<TokenInterceptorHttpClient>();

      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_apiUrl/v1/users/save-profile-details'),
      );

      // Add user profile details as fields
      request.fields['firstName'] = userProfile.firstName!;
      request.fields['lastName'] = userProfile.lastName!;
      request.fields['phoneNumber'] = userProfile.phoneNumber!;
      request.fields['address'] = userProfile.address!;

      // Add profile picture file
      await addImageFileToUserDetailsRequest(
          request, userProfile.profileImageFile);

      // Send the multipart request with token interceptor
      final streamedResponse = await tokenInterceptor.send(request);

      // Get response from streamed response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // User details saved successfully
        print('User details saved successfully');
      } else {
        // Handle error case
        print(
            'Failed to save user details. Server returned status code: ${response.statusCode}');
        throw Exception('Failed to save user details');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to save user details');
    }
  }

  Future<void> addImageFileToUserDetailsRequest(
    http.MultipartRequest request,
    XFile? imageFile,
  ) async {
    if (imageFile != null) {
      try {
        if (kIsWeb) {
          // Use fromBytes for web environments
          List<int> imageBytes = await imageFile.readAsBytes();
          var imagePart = http.MultipartFile.fromBytes(
            'profilePicture',
            imageBytes,
            filename: imageFile.path.replaceAll(' ', '_') + '.jpg',
            contentType: MediaType('application', 'octet-stream'),
          );

          request.files.add(imagePart);
        } else {
          // Use fromPath for non-web environments
          var imagePart = await http.MultipartFile.fromPath(
            'profilePicture',
            imageFile.path,
            filename: imageFile.path.replaceAll(' ', '_') + '.jpg',
          );
          request.files.add(imagePart);
        }
      } catch (e) {
        print('Error adding image file to request: $e');
        // Handle the error appropriately
        throw Exception('Failed to add image file to the request');
      }
    }
  }

  Future<Uint8List> getProfilePic() async {
    try {
      // Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // Check if the token is available
      if (token == null) {
        throw Exception('Token not found');
      }

      // Prepare the request headers with the token
      final headers = {
        'Authorization': 'Bearer $token',
      };

      // Make a GET request to the server to fetch the profile picture
      final response = await http.get(
        Uri.parse('$_apiUrl/v1/users/profile-pic'),
        headers: headers,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Return the profile picture content as a list of bytes
        return response.bodyBytes;
      } else {
        // Handle error case
        print('Failed to fetch profile picture: ${response.statusCode}');
        throw Exception('Failed to fetch profile picture');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to fetch profile picture');
    }
  }

  Future<Uint8List> getProfilePicOfUser(String userId) async {
    try {
      // Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // Check if the token is available
      if (token == null) {
        throw Exception('Token not found');
      }

      // Prepare the request headers with the token
      final headers = {
        'Authorization': 'Bearer $token',
      };

      // Make a GET request to the server to fetch the profile picture
      final response = await http.get(
        Uri.parse('$_apiUrl/v1/users/profile-pic/'+userId),
        headers: headers,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Return the profile picture content as a list of bytes
        return response.bodyBytes;
      } else {
        // Handle error case
        print('Failed to fetch profile picture: ${response.statusCode}');
        throw Exception('Failed to fetch profile picture');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to fetch profile picture');
    }
  }

  Future<UserProfile> getUserProfile() async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
          GetIt.instance<TokenInterceptorHttpClient>();

      final response = await tokenInterceptor
          .get(Uri.parse('$_apiUrl/v1/users/user-profile'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> userData = json.decode(response.body);

        // Extract user profile details from the JSON response
        final String? firstName = userData['firstName'];
        final String? lastName = userData['lastName'];
        final String? phoneNumber = userData['phoneNumber'];
        final String? address = userData['address'];

        // Create a UserProfile object with the parsed data
        final UserProfile userProfile = UserProfile(
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          address: address,
        );

        return userProfile;
      } else {
        // Handle error case
        print('Failed to fetch user profile: ${response.statusCode}');
        throw Exception('Failed to fetch user profile');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to fetch user profile');
    }
  }

  Future<void> logout() async {
    try {
      // Call the backend logout API
      final response = await http.post(
        Uri.parse('$_apiUrl/logout'),
        headers: {'Content-Type': 'application/json'},
        // You may need to include the token in the headers for authentication
        // Example: {'Authorization': 'Bearer $token'}
      );

      // Check if the backend logout was successful
      if (response.statusCode == 200) {
        // Clear the token from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
      } else {
        // Handle error case
        print('Failed to logout from backend: ${response.statusCode}');
        throw Exception('Failed to logout');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to logout');
    }
  }

  Future<List<int>> getDisplayImageForCurrentTime() async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
          getIt<TokenInterceptorHttpClient>();
      final response = await tokenInterceptor.get(
        Uri.parse('$_apiUrl/v1/play/current-time-image'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Return the display image content as a list of bytes
        return response.bodyBytes;
      } else if (response.statusCode == 404) {
        // No display image found for the current time
        return [];
      } else {
        // Handle other error cases
        print('Failed to fetch display image: ${response.statusCode}');
        throw Exception('Failed to fetch display image');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to fetch display image');
    }
  }

  Future<void> playAudit(String displayId, String boardId) async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
          GetIt.instance<TokenInterceptorHttpClient>();
      final response = await tokenInterceptor.post(
        Uri.parse('$_apiUrl/v1/play/audit/$displayId/$boardId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Play audit saved successfully
        print('Play audit saved successfully');
      } else {
        // Handle error case
        print(
            'Failed to save play audit. Server returned status code: ${response.statusCode}');
        throw Exception('Failed to save play audit');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to save play audit');
    }
  }
}
