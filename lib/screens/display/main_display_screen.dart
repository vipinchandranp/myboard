import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myboard/screens/display/create_display/create_display_screen.dart';
import 'package:myboard/screens/display/route/create_route_screen.dart';
import 'package:myboard/screens/display/route/view_route_screen.dart';
import 'package:myboard/screens/display/view_display/view_mydisplay_my_displays_on_map.dart';
import 'package:myboard/screens/location/AutocompleteLocationSearchBar.dart';

class MainDisplayScreen extends StatefulWidget {
  @override
  _MainDisplayScreenState createState() => _MainDisplayScreenState();
}

class _MainDisplayScreenState extends State<MainDisplayScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _currentIndex = 0;
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Display'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.create), text: 'Create Display'),
              Tab(icon: Icon(Icons.remove_red_eye), text: 'View Display'),
              Tab(icon: Icon(Icons.map), text: 'Create Route'),
              Tab(icon: Icon(Icons.directions), text: 'View Route'),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue, Colors.red],
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
            Column(
              children: [
                AutocompleteLocationSearchBar(),
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      CreateDisplayScreen(),
                      MyDisplaysOnMapScreen(),
                      CreateRouteScreen(),
                      ViewRouteScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
