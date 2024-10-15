import 'package:flutter/material.dart';
import '../../api_models/timeslot_status_response.dart';
import '../../repository/timeslot_repository.dart';

class TimeslotStatusWidget extends StatefulWidget {
  @override
  _TimeslotStatusWidgetState createState() => _TimeslotStatusWidgetState();
}

class _TimeslotStatusWidgetState extends State<TimeslotStatusWidget> {
  late Future<List<TimeslotStatusResponse>?> timeslotStatusFuture;

  // Map to store approval status for each timeslot
  Map<String, bool> approvalStatus = {};

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch timeslot statuses
    timeslotStatusFuture = TimeSlotService(context).getTimeslotStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timeslot Status',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
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
                  timeslotStatusFuture = TimeSlotService(context)
                      .getTimeslotStatus(); // Retry fetching data
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
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
      ),
    );
  }

  // List of Timeslots Widget
  Widget _buildTimeslotList(List<TimeslotStatusResponse> timeslotList) {
    return ListView.separated(
      itemCount: timeslotList.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: Colors.grey[300]),
      itemBuilder: (context, index) {
        final timeslot = timeslotList[index];
        return _buildTimeslotCard(timeslot);
      },
    );
  }

  // Individual Timeslot Card Widget
  Widget _buildTimeslotCard(TimeslotStatusResponse timeslot) {
    // Initialize approval status for the timeslot if not already set
    approvalStatus.putIfAbsent(timeslot.timeslotId, () => false);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4, // Add elevation for a raised effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: ListTile(
        title: Text(
          timeslot.boardName, // Show board name instead of ID
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timeslot.displayName, // Show display name instead of ID
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Status: ${timeslot.status}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatDate(timeslot.date),
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(width: 10),
            Switch(
              value: approvalStatus[timeslot.timeslotId]!,
              activeColor: Colors.green, // Color when approved
              inactiveThumbColor: Colors.red, // Color when not approved
              onChanged: (value) {
                setState(() {
                  approvalStatus[timeslot.timeslotId] =
                      value; // Update approval status
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to format DateTime in a user-friendly format
  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
