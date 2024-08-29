import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:myboard/models/UserProfile.dart';
import 'package:myboard/repositories/user_repository.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _firstName;
  String? _lastName;
  String? _phoneNumber;
  String? _address;
  XFile? _pickedFile; // Changed from File to XFile
  final ImagePicker _imagePicker = ImagePicker();
  final userRepository = GetIt.instance<UserRepository>();

  @override
  void initState() {
    super.initState();
    // Fetch user profile data when the screen is initialized
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    try {
      UserProfile userProfile = await userRepository.getUserProfile();
      // Set the initial values of form fields from the fetched user profile data
      setState(() {
        _firstName = userProfile.firstName;
        _lastName = userProfile.lastName;
        _phoneNumber = userProfile.phoneNumber;
        _address = userProfile.address;
        // Load profile picture from API
        _loadProfilePicture();
      });
    } catch (e) {
      print('Failed to load user details: $e');
    }
  }

  Future<void> _loadProfilePicture() async {
    try {
      // Call the method to get the profile picture bytes
      List<int> imageData = await userRepository.getProfilePic();
      // Set the profile picture file using the retrieved bytes
      setState(() {
        _pickedFile = XFile.fromData(Uint8List.fromList(imageData));
      });
    } catch (e) {
      print('Failed to load profile picture: $e');
    }
  }

  Future<void> _getImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  void _saveUserDetails(BuildContext context) {
    // Check if profile picture is selected
    if (_pickedFile == null) {
      // If profile picture is not selected, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a profile picture'),
          duration: Duration(seconds: 2),
        ),
      );
      return; // Exit the method early
    }

    // Create a UserProfile object with the entered details
    UserProfile userProfile = UserProfile(
      firstName: _firstName ?? '',
      lastName: _lastName ?? '',
      phoneNumber: _phoneNumber ?? '',
      address: _address ?? '',
      profileImageFile:
          XFile(_pickedFile!.path), // Pass the selected profile picture file
    );

    // Call the saveUserProfile method from the UserRepository
    userRepository.saveUserProfile(userProfile).then((_) {
      // If the saving is successful, show a snackbar notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User profile saved successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }).catchError((error) {
      // If there's an error while saving, show a snackbar notification with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving user profile: $error'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserProfile>(
        future: userRepository.getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            UserProfile? userProfile = snapshot.data;
            if (userProfile == null) {
              userProfile = UserProfile(
                firstName: '',
                lastName: '',
                phoneNumber: '',
                address: '',
              );
            }
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: _getImage,
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        Container(
                                          width: 160,
                                          height: 160,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                          child: _pickedFile != null
                                              ? ClipOval(
                                                  child:
                                                      FutureBuilder<Uint8List>(
                                                    future: _pickedFile!
                                                        .readAsBytes(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Image.memory(
                                                          snapshot.data!,
                                                          height: 200,
                                                          fit: BoxFit.cover,
                                                        );
                                                      } else {
                                                        return CircularProgressIndicator();
                                                      }
                                                    },
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  radius: 80,
                                                  backgroundImage: AssetImage(
                                                    'assets/myboard_logo.png',
                                                  ),
                                                ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  _buildFormField(
                                    'First Name',
                                    initialValue: userProfile.firstName,
                                  ),
                                  SizedBox(height: 20),
                                  _buildFormField(
                                    'Last Name',
                                    initialValue: userProfile.lastName,
                                  ),
                                  SizedBox(height: 20),
                                  // Use IntlPhoneField with initialCountryCode set to 'IN' to show only Indian flag
                                  IntlPhoneField(
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      labelStyle:
                                          TextStyle(color: Colors.indigo),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.indigo,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 16),
                                      filled: true,
                                      fillColor: Colors.white,
                                      errorStyle: TextStyle(color: Colors.red),
                                    ),
                                    initialCountryCode: 'IN',
                                    // Set initial country code to India
                                    initialValue: userProfile.phoneNumber,
                                  ),
                                  SizedBox(height: 20),
                                  TextField(
                                    maxLines: 10,
                                    decoration: InputDecoration(
                                      labelText: 'Address',
                                      labelStyle:
                                          TextStyle(color: Colors.indigo),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.indigo,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 16),
                                      filled: true,
                                      fillColor: Colors.white,
                                      errorStyle: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  FloatingActionButton.extended(
                                    onPressed: () {
                                      _saveUserDetails(context);
                                    },
                                    label: Text('Save'),
                                    icon: Icon(Icons.save),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildFormField(String labelText, {String? initialValue}) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.indigo),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.indigo,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        filled: true,
        fillColor: Colors.white,
        errorStyle: TextStyle(color: Colors.red),
      ),
    );
  }
}
