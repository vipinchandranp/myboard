import 'package:flutter/material.dart';
import 'package:myboard/screens/create_board_screen.dart';
import 'package:myboard/screens/notification_screen.dart';
import 'package:myboard/screens/pin_board_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset('assets/myboard_logo1.png'),
              onPressed: () {
                // Open the drawer when the menu icon is pressed
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text('My Board'),
        backgroundColor: Colors.blueGrey[800],
        actions: [
          IconButton(
            onPressed: () {
              // Handle button pressed
              // Add your logic here
            },
            icon: Icon(Icons.shopping_cart, color: Colors.teal),
          ),
          IconButton(
            onPressed: () {
              // Open the notification screen when the notification icon is clicked
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
            icon: Icon(Icons.notifications, color: Colors.teal),
          ),
          IconButton(
            onPressed: () {
              // Handle button pressed
              // Add your logic here
            },
            icon: Icon(Icons.settings, color: Colors.teal),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: 'Create Board',
              icon: Icon(Icons.create),
            ),
            Tab(
              text: 'Pin',
              icon: Icon(Icons.push_pin),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile_image.jpg'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'My Board',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Handle drawer item tap
                // Add your logic here
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                // Handle drawer item tap
                // Add your logic here
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle drawer item tap
                // Add your logic here
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle drawer item tap
                // Add your logic here
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CreateBoardScreen(),
          PinBoardScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 56,
        color: Colors.blueGrey[800],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                // Handle play button pressed
                // Add your logic here
              },
              icon: Icon(Icons.play_arrow, color: Colors.white),
            ),
            Text(
              'MyBoards 2023',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
