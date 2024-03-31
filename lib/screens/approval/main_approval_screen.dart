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
                Tab(text: 'Incoming Approvals'),
                Tab(text: 'Outgoing Approvals'),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                IncomingRequestsScreen(),
                OutgoingRequestsScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
