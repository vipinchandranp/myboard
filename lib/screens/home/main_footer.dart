import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myboard/themes/app_theme.dart';

class MainFooterWidget extends StatefulWidget {
  @override
  _MainFooterWidgetState createState() => _MainFooterWidgetState();
}

class _MainFooterWidgetState extends State<MainFooterWidget> {
  int _bottomNavIndex = 0; // To keep track of the selected index

  final List<IconData> _icons = [
    FontAwesomeIcons.home,
    FontAwesomeIcons.cog,
    FontAwesomeIcons.bell, // Adding more icons for better functionality
    FontAwesomeIcons.userCircle,
  ];
  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar(
      icons: _icons,
      backgroundColor: Colors.white, // Changed to light teal for consistency
      activeIndex: _bottomNavIndex,
      gapLocation: GapLocation.center,
      onTap: (index) {
        setState(() {
          _bottomNavIndex = index; // Update the selected index
          // Navigation logic can be added here based on the selected index
          // For example: Navigator.push(...);
        });
      },
      elevation: 8,
      notchSmoothness: NotchSmoothness.softEdge,
      // Set the color of the icons
      inactiveColor: Colors.blueGrey,
      activeColor: Colors.teal, // Color of the active icon
    );
  }

}
