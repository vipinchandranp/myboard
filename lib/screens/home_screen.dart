import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Center(
        child: Text('Home Screen Content'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle settings menu item press
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Account Settings'),
              onTap: () {
                // Handle account settings menu item press
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile Settings'),
              onTap: () {
                // Handle profile settings menu item press
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Payments'),
              onTap: () {
                // Handle payments menu item press
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Maps'),
              onTap: () {
                // Handle maps menu item press
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search'),
              onTap: () {
                // Handle search menu item press
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}
