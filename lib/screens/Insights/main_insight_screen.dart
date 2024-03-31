import 'package:flutter/material.dart';

class InsightScreen extends StatefulWidget {
  @override
  _InsightScreenState createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen>
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
                Tab(text: 'Incoming Requests'),
                Tab(text: 'Board Approvals'),
                Tab(text: 'Performance'),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                DashboardSection(
                  title: 'Incoming Requests for Approvals',
                  count: 3,
                  onTap: () {
                    // Navigate to requests screen
                  },
                ),
                DashboardSection(
                  title: 'Status of Board Approvals',
                  count: 2,
                  onTap: () {
                    // Navigate to board approvals status screen
                  },
                ),
                DashboardSection(
                  title: 'Performance of My Board',
                  hasGraph: true,
                  onTap: () {
                    // Navigate to performance details screen
                  },
                  count: null,
                ),
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

class DashboardSection extends StatelessWidget {
  final String title;
  final int? count;
  final bool hasGraph;
  final VoidCallback onTap;

  DashboardSection({
    required this.title,
    required this.count,
    this.hasGraph = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  count?.toString() ?? 'N/A',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (hasGraph)
              Icon(
                Icons.show_chart,
                size: 30,
                color: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }
}
