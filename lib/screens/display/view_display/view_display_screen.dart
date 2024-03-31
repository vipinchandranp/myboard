import 'package:flutter/material.dart';
import 'package:myboard/screens/board/create_board/createboard_screen.dart';
import 'package:myboard/screens/board/view_board/view_board_screen.dart';

class ViewDisplayScreen extends StatefulWidget {
  @override
  _ViewDisplayScreenState createState() => _ViewDisplayScreenState();
}

class _ViewDisplayScreenState extends State<ViewDisplayScreen>
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
