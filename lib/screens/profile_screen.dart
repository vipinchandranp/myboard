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
  XFile? _pickedFile; // Changed from XFile to File
  final ImagePicker _imagePicker = ImagePicker();
  final userRepository = GetIt.instance<UserRepository>();



  Future<void> _getImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = XFile(pickedFile.path);
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
      profileImageFile: _pickedFile, // Pass the selected profile picture file
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
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Center(
                    child: GestureDetector(
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
                                    child: Image.network(
                                      _pickedFile!.path,
                                      height: 200,
                                      fit: BoxFit.cover,
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
                  ),
                  SizedBox(height: 20),
                  _buildFormField('First Name', onChanged: (value) {
                    setState(() {
                      _firstName = value;
                    });
                  }),
                  SizedBox(height: 20),
                  _buildFormField('Last Name', onChanged: (value) {
                    setState(() {
                      _lastName = value;
                    });
                  }),
                  SizedBox(height: 20),
                  // Use IntlPhoneField with initialCountryCode set to 'IN' to show only Indian flag
                  IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      filled: true,
                      fillColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    initialCountryCode: 'IN',
                    // Set initial country code to India
                    onChanged: (phone) {
                      setState(() {
                        _phoneNumber = phone.completeNumber;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _address = value;
                      });
                    },
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: 'Address',
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
        ],
      ),
    );
  }

  Widget _buildFormField(String labelText,
      {String? initialValue, required ValueChanged<String> onChanged}) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
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
