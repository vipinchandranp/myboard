import 'package:flutter/material.dart';
import 'package:myboard/screens/notification/notification_list.dart';
import '../../themes/app_theme.dart';
import '../approval/ApproveBoardForDisplay.dart';
import '../board/create_board.dart';
import '../display/create_display.dart';
import '../display/view_displays.dart';
import '../board/view_boards.dart';
import '../user/login_screen.dart';
import '../user/mb_user_profile.dart';

class MainToolsWidget extends StatelessWidget {
  const MainToolsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              title: "Display",
              actions: [
                _buildQuickActionIcon(
                  icon: Icons.display_settings,
                  label: "Create Display",
                  onTap: () => _navigateTo(context, CreateDisplayWidget()),
                ),
                _buildQuickActionIcon(
                  icon: Icons.view_list,
                  label: "My Displays",
                  onTap: () => _navigateTo(context, ViewDisplayWidget()),
                ),
                _buildQuickActionIcon(
                  icon: Icons.approval,
                  label: "Approvals",
                  onTap: () => _navigateTo(context, AvailableDatesWidget()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDivider(),
            const SizedBox(height: 16),
            _buildSection(
              context,
              title: "Boards",
              actions: [
                _buildQuickActionIcon(
                  icon: Icons.create,
                  label: "Create Board",
                  onTap: () => _navigateTo(context, CreateBoardWidget()),
                ),
                _buildQuickActionIcon(
                  icon: Icons.view_agenda,
                  label: "My Boards",
                  onTap: () => _navigateTo(context, ViewBoardsWidget()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDivider(),
            const SizedBox(height: 16),
            _buildSection(
              context,
              title: "Notifications",
              actions: [
                _buildQuickActionIcon(
                  icon: Icons.notifications,
                  label: "Notifications",
                  onTap: () => _navigateTo(context, NotificationListWidget()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDivider(),
            const SizedBox(height: 16),
            _buildSection(
              context,
              title: "Account",
              actions: [
                _buildQuickActionIcon(
                  icon: Icons.account_circle,
                  label: "Profile",
                  onTap: () => _navigateTo(context, MBUserProfile(editable: true,)),
                ),
                _buildQuickActionIcon(
                  icon: Icons.logout,
                  label: "Logout",
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> actions}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: actions.map((action) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: action,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppTheme.lightTheme.primaryColor.withOpacity(0.5),
      thickness: 1,
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _showFeatureComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("This feature is coming soon!")),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  Widget _buildQuickActionIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppTheme.lightTheme.primaryColor.withOpacity(0.2),
            child: Icon(icon, size: 28, color: AppTheme.lightTheme.primaryColor),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
