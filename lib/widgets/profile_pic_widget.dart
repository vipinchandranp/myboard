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
    // For now, call the change profile pic method
    _changeProfilePic();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: _profilePic?.image ?? AssetImage('assets/default_profile.png'),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: _editProfilePic,
            tooltip: 'Edit profile picture',
            color: Colors.blueAccent,
            iconSize: 24,
          ),
        ),
      ],
    );
  }
}
