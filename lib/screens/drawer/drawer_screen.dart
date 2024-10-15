import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Add this package for image picking
import 'package:myboard/screens/approval/timeslot_status_for_approval.dart';
import 'package:myboard/screens/board/view_boards.dart';
import 'package:myboard/screens/display/view_displays.dart';
import 'package:myboard/screens/home/home_screen.dart';
import 'package:myboard/screens/settings/settings_screen.dart';
import 'package:myboard/screens/user/login_screen.dart';
import 'package:myboard/widgets/profile_pic_widget.dart';
import '../../repository/user_repository.dart'; // Import UserService

class DrawerWidget extends StatefulWidget {
  final VoidCallback onDrawerOpened;

  DrawerWidget({required this.onDrawerOpened});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    super.initState();
    // Optionally, you could call _loadProfilePic() here as well
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(50)),
      child: Drawer(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            _buildDrawerHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _createDrawerItem(
                    context,
                    icon: Icons.home,
                    text: 'Home',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen(context)),
                      );
                    },
                  ),
                  _buildDivider(context),
                  _createDrawerItem(
                    context,
                    icon: Icons.display_settings,
                    text: 'My Displays',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewDisplayWidget()),
                      );
                    },
                  ),
                  _buildDivider(context),
                  _createDrawerItem(
                    context,
                    icon: Icons.note,
                    text: 'My Boards',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewBoardsWidget()),
                      );
                    },
                  ),
                  _buildDivider(context),
                  _createDrawerItem(
                    context,
                    icon: Icons.approval,
                    text: 'Approvals',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TimeslotStatusWidget()),
                      );
                    },
                  ),
                  _buildDivider(context),
                  _createDrawerItem(
                    context,
                    icon: Icons.settings,
                    text: 'Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()),
                      );
                    },
                  ),
                  _buildDivider(context),
                  _createDrawerItem(
                    context,
                    icon: Icons.logout,
                    text: 'Logout',
                    onTap: () {
                      // Handle logout logic and navigate to LoginScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.appBarTheme.backgroundColor!, theme.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            // Wrapping ProfilePictureWidget in Flexible to avoid overflow
            Flexible(
              child: ProfilePictureWidget(),
              flex: 2, // Adjust the flex value as needed
            ),
            SizedBox(width: 16),
            // Expanded to ensure the text doesn't overflow
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'user.email@example.com',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Icon(icon, color: theme.iconTheme.color),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: theme.iconTheme.color),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(
        color: theme.dividerColor,
        height: 1,
      ),
    );
  }
}
