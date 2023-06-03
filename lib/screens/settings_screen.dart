import 'package:flutter/material.dart';
import 'change_password_screen.dart';
import 'update_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        children: [
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            onTap: () {
              // Handle change password action
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Update Profile'),
            onTap: () {
              // Handle update profile action
              Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProfileScreen()));
            },
          ),
          // Add more settings options here
        ],
      ),
    );
  }
}
