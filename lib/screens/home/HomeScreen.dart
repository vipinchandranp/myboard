import 'package:flutter/material.dart';
import 'package:myboard/screens/display/all_nearby_displays.dart';
import 'package:myboard/screens/display/view_display/view_display_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AllNearbyDisplaysMapScreen(),
        ],
      ),
    );
  }
}
