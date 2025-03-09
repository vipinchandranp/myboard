import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import '../../utils/utility.dart';
import '../approval/ApproveBoardForDisplay.dart';
import '../board/create_board.dart';
import '../display/create_display.dart';
import '../display/view_displays.dart';
import '../board/view_boards.dart';
import '../notification/notification_list.dart';
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
                Utility.buildActionIcon(
                  assetPath: 'assets/create-display.png',
                  label: "Create Display",
                  onTap: () => _navigateTo(context, CreateDisplayWidget()),
                ),
                Utility.buildActionIcon(
                  assetPath: "assets/list.png",
                  label: "My Displays",
                  onTap: () => _navigateTo(context, ViewDisplayWidget()),
                ),
                Utility.buildActionIcon(
                  assetPath: 'assets/approvals.png',
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
                Utility.buildActionIcon(
                  assetPath: "assets/create-board.png",
                  label: "Create Board",
                  onTap: () => _navigateTo(context, CreateBoardWidget()),
                ),
                Utility.buildActionIcon(
                  assetPath: "assets/list.png",
                  label: "My Boards",
                  onTap: () => _navigateTo(context, ViewBoardsWidget()),
                ),
                Utility.buildActionIcon(
                  assetPath: 'assets/approvals.png',
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
              title: "Notifications",
              actions: [
                Utility.buildActionIcon(
                  assetPath: 'assets/notification.png',
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
                Utility.buildActionIcon(
                  assetPath: 'assets/profile.png',
                  label: "Profile",
                  onTap: () => _navigateTo(context, MBUserProfile(editable: true)),
                ),
                Utility.buildActionIcon(
                  assetPath: 'assets/logout.png',
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

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }
}
