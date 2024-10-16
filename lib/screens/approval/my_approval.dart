import 'package:flutter/material.dart';
import 'package:myboard/screens/approval/timeslot_card.dart';
import '../../api_models/timeslot_status_response.dart';
import '../../repository/approval_repository.dart';

// Main Widget
class MyApprovalWidget extends StatefulWidget {
  @override
  _MyApprovalWidgetState createState() => _MyApprovalWidgetState();
}

class _MyApprovalWidgetState extends State<MyApprovalWidget> {
  late Future<List<TimeslotStatusResponse>?> timeslotStatusFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch timeslot statuses
    timeslotStatusFuture = ApprovalService(context).getTimeslotStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timeslot Status', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<TimeslotStatusResponse>?>(
        future: timeslotStatusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator(); // Loading state
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error); // Error state
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(); // Empty state
          } else {
            final timeslotList = snapshot.data!;
            return _buildTimeslotList(timeslotList);
          }
        },
      ),
    );
  }

  // Loading Indicator Widget
  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      ),
    );
  }

  // Error Widget
  Widget _buildErrorWidget(Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text('Error: $error', textAlign: TextAlign.center),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  timeslotStatusFuture = ApprovalService(context).getTimeslotStatus(); // Retry fetching data
                });
              },
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No timeslots available',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }

  // List of Timeslots Widget
  Widget _buildTimeslotList(List<TimeslotStatusResponse> timeslotList) {
    return SingleChildScrollView( // Wrap the ListView in a SingleChildScrollView
      child: Column(
        children: [
          ListView.separated(
            physics: NeverScrollableScrollPhysics(), // Prevent ListView from scrolling independently
            shrinkWrap: true, // Allows the ListView to occupy only as much space as needed
            itemCount: timeslotList.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
            itemBuilder: (context, index) {
              final timeslot = timeslotList[index];
              return TimeslotCard(
                timeslot: timeslot,
                onStatusChanged: () {
                  // Reload timeslot statuses after approval change
                  setState(() {
                    timeslotStatusFuture = ApprovalService(context).getTimeslotStatus();
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
