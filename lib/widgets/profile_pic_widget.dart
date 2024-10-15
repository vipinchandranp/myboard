import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myboard/repository/user_repository.dart';

class ProfilePictureWidget extends StatefulWidget {
  @override
  _ProfilePictureWidgetState createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  late UserService _userService;
  Image? _profilePic;
  bool _loading = true;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userService = UserService(context);
    _loadProfilePic();
  }

  Future<void> _loadProfilePic() async {
    try {
      final image = await _userService.getProfilePic();
      setState(() {
        _profilePic = image;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load profile picture: $e';
        _loading = false;
      });
    }
  }

  Future<void> _changeProfilePic() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        await _userService.saveProfilePic(pickedFile);
        _loadProfilePic(); // Refresh the profile picture
      } catch (e) {
        print('Failed to upload profile picture: $e');
      }
    }
  }

  void _editProfilePic() {
    _changeProfilePic();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        // Profile picture or default image
        CircleAvatar(
          radius: 50,
          backgroundImage:
              _profilePic?.image ?? AssetImage('assets/default_profile.png'),
          backgroundColor:
              Colors.grey[200], // Optional background color for empty avatar
        ),
        // Edit icon button, always visible
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // White background for better visibility
            ),
            child: IconButton(
              icon: Icon(Icons.edit, color: Colors.blueAccent),
              // White background, blue accent icon
              onPressed: _editProfilePic,
              tooltip: 'Edit profile picture',
              iconSize: 24,
            ),
          ),
        ),
      ],
    );
  }
}
