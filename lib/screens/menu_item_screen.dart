import 'package:flutter/material.dart';
import 'package:myboard/screens/create_board_screen.dart';
import 'package:myboard/screens/pin_board_screen.dart';

class MenuItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7986CB),
              Color(0xFFE8EAF6),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          children: [
            MenuItemCard(
              icon: Icons.person,
              title: 'Approval Requests',
              onTap: () {
                // Handle the "View Other Boards" action here
                print('View Other Boards tapped');
              },
            ),            // Add more MenuItemCard widgets for additional items
          ],
        ),
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  MenuItemCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
