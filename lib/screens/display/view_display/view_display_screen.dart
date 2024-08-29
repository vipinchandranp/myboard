import 'package:flutter/material.dart';

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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 16.0,
              ),
              Container(
                width: constraints.maxWidth * 0.8, // 80% of screen width
                height: constraints.maxHeight * 0.6, // 60% of screen height
                // Add your content here
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}