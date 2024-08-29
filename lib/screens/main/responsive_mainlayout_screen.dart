import 'dart:typed_data';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/repositories/user_repository.dart';
import 'package:myboard/screens/account/main_account_screen.dart';
import 'package:myboard/screens/approval/main_approval_screen.dart';
import 'package:myboard/screens/board/main_board_screen.dart';
import 'package:myboard/screens/display/create_display/create_display_screen.dart';
import 'package:myboard/screens/display/main_display_screen.dart';
import 'package:myboard/screens/home/HomeScreen.dart';
import 'package:myboard/screens/location/AutocompleteLocationSearchBar.dart';

class ResponsiveMainScreen extends StatefulWidget {
  @override
  _ResponsiveMainScreenState createState() => _ResponsiveMainScreenState();
}

class _ResponsiveMainScreenState extends State<ResponsiveMainScreen> {
  List<int> _profilePic = [];
  final userRepository = GetIt.instance<UserRepository>();
  late MyBoardUser myBoardUser = MyBoardUser(id: '', username: '');
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();
  final List<String> sampleItems = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ]; // Sample items for carousel

  @override
  void initState() {
    super.initState();
    _loadProfilePic();
    _initUser();
  }

  void _initUser() async {
    try {
      myBoardUser = await userRepository.initUser();
      setState(() {});
      print(myBoardUser);
    } catch (e) {
      print('Failed to fetch saved location: $e');
    }
  }

  void _loadProfilePic() async {
    try {
      final profilePic = await userRepository.getProfilePic();
      setState(() {
        _profilePic = profilePic;
      });
    } catch (e) {
      print('Failed to load profile picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFEAE3E3), // Brown at the bottom
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/myboard_logo_round.png',
              width: 60,
              height: 60,
            ),
            SizedBox(width: 8),
            Text("Display Board"),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 15,
                backgroundImage: MemoryImage(Uint8List.fromList(_profilePic)),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Expanded(
                            child: AutocompleteLocationSearchBar(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 1),
                  HomeScreen()
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.more), label: 'More'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (int index) {
          // Handle bottom navigation item taps
          switch (index) {
            case 1: // Index of the "More" button
              _showMoreOptions(context); // Show the bottom slider
              break;
            default:
              break;
          }
        },
      ),
    );
  }

  Widget _buildCarouselItem(String item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          item,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.smart_display),
                  title: Row(
                    children: [
                      Text('Display'),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainDisplayScreen(),
                      ),
                    );
                  },
                ),
                Divider(), // Horizontal line separator
                ListTile(
                  leading: Icon(Icons.post_add_outlined),
                  title: Row(
                    children: [
                      Text('Board'),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainBoardScreen(),
                      ),
                    );
                  },
                ),
                Divider(), // Horizontal line separator
                ListTile(
                  leading: Icon(Icons.analytics),
                  title: Row(
                    children: [
                      Text('Analytics'),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  onTap: () {
                    // Handle option tap
                    Navigator.pop(context); // Close the bottom sheet
                    // Add your action here
                  },
                ),
                Divider(), // Horizontal line separator
                ListTile(
                  leading: Icon(Icons.approval),
                  title: Row(
                    children: [
                      Text('Approvals'),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApprovalsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLocationSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Location Search',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              // Your autocomplete location search bar widget goes here
              // Replace the placeholder below with your actual location search bar widget
              Placeholder(
                color: Colors.grey,
                fallbackWidth: double.infinity,
                fallbackHeight: 200.0,
              ),
            ],
          ),
        );
      },
    );
  }
}
