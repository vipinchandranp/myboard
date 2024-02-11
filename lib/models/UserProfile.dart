import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class UserProfile {
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? address;
  XFile? profileImageFile; // Changed profileImagePath to profileImageFile

  UserProfile({
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.address,
    this.profileImageFile,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      // Deserialize profile image path from JSON
      profileImageFile: json['profileImageFile'] != null
          ? XFile(json['profileImageFile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'address': address,
      // Serialize profile image path to JSON
      'profileImageFile': profileImageFile?.path,
    };
  }

  // Convert JSON string to UserProfile object
  static UserProfile fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return UserProfile.fromJson(jsonMap);
  }

  // Convert UserProfile object to JSON string
  String toJsonString() {
    final Map<String, dynamic> jsonMap = toJson();
    return json.encode(jsonMap);
  }
}
