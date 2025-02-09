import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../themes/app_theme.dart';
import '../approval/available_dates.dart';
import '../board/create_board.dart';
import '../display/create_display.dart';
import '../display/nearby_display_map.dart';
import '../display/view_displays.dart';
import '../board/view_boards.dart';
import '../qrcode/qr_scanner.dart';
import '../user/login_screen.dart';
import '../user/mb_user_profile.dart';

class MainToolsWidget extends StatelessWidget {
  final BuildContext context;

  MainToolsWidget(this.context);

  @override
  Widget build(BuildContext context) {
    final double gridItemWidth = MediaQuery.of(context).size.width / 4 - 16;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: gridItemWidth / (gridItemWidth + 30),
        ),
        itemCount: 9,
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return _buildGridButton(
                context,
                icon: FontAwesomeIcons.display,
                text: 'Create\nDisplay',
                onTap: () => navigateTo(CreateDisplayWidget()),
              );
            case 1:
              return _buildGridButton(
                context,
                icon: FontAwesomeIcons.chalkboard,
                text: 'Create\nBoard',
                onTap: () => navigateTo(CreateBoardWidget(context)),
              );
            case 2:
              return _buildGridButton(
                context,
                icon: FontAwesomeIcons.tv,
                text: 'View\nDisplays',
                onTap: () => navigateTo(ViewDisplayWidget()),
              );
            case 3:
              return _buildGridButton(
                context,
                icon: FontAwesomeIcons.list,
                text: 'View\nBoards',
                onTap: () => navigateTo(ViewBoardsWidget()),
              );
            case 4:
              return _buildGridButton(
                context,
                icon: FontAwesomeIcons.thumbsUp,
                text: 'Approvals',
                onTap: () => navigateTo(AvailableDatesWidget()),
              );
            case 5:
              return _buildGridButton(
                context,
                icon: FontAwesomeIcons.mapMarkedAlt,
                text: 'Nearby\nDisplays',
                onTap: () => navigateTo(NearbyDisplaysMap()),
              );
            case 6:
              return _buildQrScannerButton(context);
            case 7:
              return _buildGridButton(
                context,
                icon: FontAwesomeIcons.userCircle,
                text: 'Profile',
                onTap: () => navigateTo(MBUserProfile()),
              );
            case 8:
              return _buildGridButton(
                context,
                icon: FontAwesomeIcons.signOutAlt,
                text: 'Logout',
                onTap: () => navigateTo(LoginScreen()),
              );
            default:
              return Container();
          }
        },
      ),
    );
  }

  void navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget _buildGridButton(
      BuildContext context, {
        required IconData icon,
        required String text,
        required VoidCallback onTap,
      }) {
    return Tooltip(
      message: text.replaceAll('\n', ' '), // Tooltip shows full text
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: AppTheme.lightTheme.primaryColor.withOpacity(0.1), // Light primary color
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            splashColor: AppTheme.lightTheme.primaryColor.withOpacity(0.2),
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FaIcon(
                    icon,
                    size: 32,
                    color: AppTheme.lightTheme.primaryColor, // Primary color for icons
                  ),
                  const SizedBox(height: 8),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor, // Primary color for text
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQrScannerButton(BuildContext context) {
    return Tooltip(
      message: 'Scan QR Code',
      child: GestureDetector(
        onTap: () async {
          final scannedData = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QRScannerWidget(),
            ),
          );

          if (scannedData != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Scanned QR Code: $scannedData')),
            );
          }
        },
        child: Card(
          color: AppTheme.lightTheme.primaryColor.withOpacity(0.1), // Light primary color
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FaIcon(
                  FontAwesomeIcons.qrcode,
                  size: 32,
                  color: AppTheme.lightTheme.primaryColor, // Primary color for icons
                ),
                const SizedBox(height: 8),
                Text(
                  'Scan QR',
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor, // Primary color for text
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
