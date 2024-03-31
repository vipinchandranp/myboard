import 'package:flutter/material.dart';
import 'package:myboard/screens/display/create_display/create_display_screen.dart';
import 'package:myboard/screens/display/route/create_route_screen.dart';
import 'package:myboard/screens/display/view_display/view_mydisplay_my_displays_on_map.dart';

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
    _tabController = TabController(length: 3, vsync: this);
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
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 16.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              color: Colors.grey[200],
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.indigo,
              tabs: [
                Tab(text: 'Create Display'),
                Tab(text: 'View Display'),
                Tab(text: 'Create Route')
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                CreateDisplayScreen(),
                // CreateBoardScreen as the content of the first tab
                MyDisplaysOnMapScreen(),
                // ViewBoardScreen as the content of the second tab
                CreateRouteScreen()
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
