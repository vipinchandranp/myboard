import 'package:flutter/material.dart';
import 'package:myboard/screens/approval/incoming/incoming_request_screen.dart';
import 'package:myboard/screens/approval/outgoing/outgoing_request_screen.dart';

class ApprovalsScreen extends StatefulWidget {
  @override
  _ApprovalsScreenState createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      appBar: AppBar(
        title: Text('Approvals'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.indigo,
          tabs: [
            Tab(
              icon: Icon(Icons.inbox), // Icon for Incoming Approvals
              text: 'Incoming Approvals',
            ),
            Tab(
              icon: Icon(Icons.outbox), // Icon for Outgoing Approvals
              text: 'Outgoing Approvals',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Card(
            margin: EdgeInsets.all(8.0),
            child: IncomingRequestsScreen(),
          ),
          Card(
            margin: EdgeInsets.all(8.0),
            child: OutgoingRequestsScreen(),
          ),
        ],
      ),
    );
  }
}
