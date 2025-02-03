import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges; // Import the badges package with a prefix
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesome package
import 'package:myboard/screens/notification/notification_card.dart';
import 'package:myboard/screens/notification/notification_icon.dart';
import 'package:myboard/types/notification_type.dart';
import '../../themes/app_theme.dart';
import '../approval/available_dates.dart';
import '../board/create_board.dart';
import '../display/create_display.dart';
import '../notification/notification_list.dart';
import '../qrcode/qr_scanner.dart';
import '../user/mb_user_profile.dart';
import 'package:myboard/screens/board/view_boards.dart';
import 'package:myboard/screens/display/view_displays.dart';
import 'package:myboard/screens/user/login_screen.dart';
import '../display/nearby_display_map.dart';

class MainToolsWidget extends StatelessWidget {
  final BuildContext context;

  MainToolsWidget(this.context); // Pass notification count through constructor

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of buttons in a row
          childAspectRatio: 1.2, // Adjusting the aspect ratio for better layout
        ),
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            switch (index) {
              case 0:
                return _buildGridButton(
                  context,
                  icon: FontAwesomeIcons.display, // FontAwesome display icon
                  text: '',
                  onTap: () => navigateTo(CreateDisplayWidget()),
                );
              case 1:
                return _buildGridButton(
                  context,
                  icon: FontAwesomeIcons.chalkboard, // FontAwesome board icon
                  text: '',
                  onTap: () => navigateTo(CreateBoardWidget(context)),
                );
              case 2:
                return _buildGridButton(
                  context,
                  icon: FontAwesomeIcons.tv, // FontAwesome TV icon
                  text: 's',
                  onTap: () => navigateTo(ViewDisplayWidget()),
                );
              case 3:
                return _buildGridButton(
                  context,
                  icon: FontAwesomeIcons.list, // FontAwesome list icon
                  text: '',
                  onTap: () => navigateTo(ViewBoardsWidget()),
                );
              case 4:
                return _buildGridButton(
                  context,
                  icon: FontAwesomeIcons.thumbsUp, // FontAwesome approval icon
                  text: '',
                  onTap: () => navigateTo(AvailableDatesWidget()),
                );
              case 5:
                return _buildGridButton(
                  context,
                  icon: FontAwesomeIcons.mapMarkedAlt, // FontAwesome map icon
                  text: '',
                  onTap: () => navigateTo(NearbyDisplaysMap()),
                );
              case 6:
                return _buildQrScannerButton(context);
              case 7:
                return _buildGridButton(
                  context,
                  icon: FontAwesomeIcons.userCircle, // FontAwesome user icon
                  text: '',
                  onTap: () => navigateTo(MBUserProfile()),
                );
              case 8:
                return _buildGridButton(
                  context,
                  icon: FontAwesomeIcons.signOutAlt, // FontAwesome logout icon
                  text: '',
                  onTap: () => navigateTo(LoginScreen()),
                );
              default:
                return Container(); // Fallback if index is out of bounds
            }
          },
          childCount: 10, // Total number of buttons
        ),
      ),
    );
  }

  void navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget _buildGridButton(BuildContext context,
      {required IconData icon,
        required String text,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.teal.shade100,
        elevation: 4, // Adds a shadow for a raised effect
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(icon, size: 36, color: AppTheme.lightTheme.primaryColor), // Use FaIcon here
              SizedBox(height: 8),
              Text(
                text,
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrScannerButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final scannedData = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRScannerWidget(),
          ),
        );

        if (scannedData != null) {
          print('Scanned QR Code: $scannedData');
        }
      },
      child: Card(
        elevation: 4, // Adds a shadow for a raised effect
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(FontAwesomeIcons.qrcode,
                  size: 36, color: AppTheme.lightTheme.primaryColor), // Use FontAwesome QR code icon
              SizedBox(height: 8),
              Text(
                'Scan QR',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
