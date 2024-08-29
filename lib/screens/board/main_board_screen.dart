import 'package:flutter/material.dart';
import 'package:myboard/screens/board/create_board/createboard_screen.dart';
import 'package:myboard/screens/board/view_board/view_board_screen.dart';

class MainBoardScreen extends StatefulWidget {
  @override
  _MainBoardScreenState createState() => _MainBoardScreenState();
}

class _MainBoardScreenState extends State<MainBoardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Board'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.create), text: 'Create Board'),
            Tab(icon: Icon(Icons.view_list), text: 'View Board'),
          ],
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          CreateBoardScreen(),
          ViewMyboardScreen(),
        ],
      ),
    );
  }
}
