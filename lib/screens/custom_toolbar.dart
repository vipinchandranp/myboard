import 'package:flutter/material.dart';

class CustomToolbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // Align items to the right
      children: <Widget>[
        _buildMenuItem('Inbox'),
        VerticalDivider(),
        _buildMenuItem('Pricing'),
        VerticalDivider(),
        _buildMenuItem('About Us'),
        VerticalDivider(),
        _buildMenuItem('Contact Us'),
        // Add more menu items and vertical dividers as needed
      ],
    );
  }

  Widget _buildMenuItem(String title) {
    return GestureDetector(
      onTap: () {
        // Handle item tap
        print('Tapped: $title');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white, // Set text color to white
          ),
        ),
      ),
    );
  }
}