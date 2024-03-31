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
                Tab(text: 'Create Board'),
                Tab(text: 'View Board'),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                CreateBoardScreen(),
                // CreateBoardScreen as the content of the first tab
                ViewMyboardScreen(),
                // ViewBoardScreen as the content of the second tab
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
