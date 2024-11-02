import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:shimmer/shimmer.dart'; // Import shimmer package
import 'package:myboard/screens/approval/timeslot_card.dart';
import '../../api_models/timeslot_status_response.dart';
import '../../api_models/timslot_status_request.dart'; // Import the request model
import '../../repository/approval_repository.dart';

class MyApprovalWidget extends StatefulWidget {
  final DateTime selectedDate; // Add selectedDate as a parameter

  MyApprovalWidget(
      {required this.selectedDate}); // Constructor to accept selectedDate

  @override
  _MyApprovalWidgetState createState() => _MyApprovalWidgetState();
}

class _MyApprovalWidgetState extends State<MyApprovalWidget> {
  late Future<List<TimeslotStatusResponse>?> timeslotStatusFuture;
  String? _expandedDisplay; // Variable to track the currently expanded display

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch timeslot statuses using the selected date
    timeslotStatusFuture = _fetchTimeslotStatus();
  }

  Future<List<TimeslotStatusResponse>?> _fetchTimeslotStatus() {
    // Create the request object with the selected date
    final request = TimeslotStatusRequest(
      date: widget.selectedDate,
      // Pass the selected date here
      displayId: null,
      displayName: null,
      boardId: null,
      boardName: null,
      status: null,
    );

    return ApprovalService(context)
        .fetchFilteredTimeslots(request); // Use the request object
  }

  @override
  Widget build(BuildContext context) {
    // Format the selected date using intl package
    final formattedDate = DateFormat('yMMMMd').format(widget.selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Timeslot details on date $formattedDate',
          // Display selected date in the AppBar
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<TimeslotStatusResponse>?>(
              future: timeslotStatusFuture, // Provide the future
              builder: (context, snapshot) {
                // Provide the builder function
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerLoading(); // Show shimmer loading effect
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
          ),
        ],
      ),
    );
  }

  // Shimmer Loading Indicator Widget
  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 6, // Show 6 shimmer placeholders
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 100, // Placeholder height simulating a card
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
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
                  timeslotStatusFuture =
                      _fetchTimeslotStatus(); // Retry fetching data
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

  // Group the timeslots by display name
  Map<String, List<TimeslotStatusResponse>> _groupTimeslotsByDisplayName(
      List<TimeslotStatusResponse> timeslotList) {
    Map<String, List<TimeslotStatusResponse>> groupedTimeslots = {};
    for (var timeslot in timeslotList) {
      final displayName = timeslot.displayName ?? 'Unknown Display';
      if (groupedTimeslots.containsKey(displayName)) {
        groupedTimeslots[displayName]!.add(timeslot);
      } else {
        groupedTimeslots[displayName] = [timeslot];
      }
    }
    return groupedTimeslots;
  }

// List of Timeslots grouped by display
  Widget _buildTimeslotList(List<TimeslotStatusResponse> timeslotList) {
    final groupedTimeslots = _groupTimeslotsByDisplayName(timeslotList);

    return ListView.separated(
      itemCount: groupedTimeslots.keys.length,
      separatorBuilder: (context, index) => Divider(
        thickness: 1.0, // Adjust the thickness of the line
        color: Colors.grey, // Customize the color of the separator
      ), // Add a divider between each display
      itemBuilder: (context, index) {
        final displayName = groupedTimeslots.keys.elementAt(index);
        final timeslotsForDisplay = groupedTimeslots[displayName]!;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.grey[200], // Slight background color
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black12, // Soft shadow for better visual effect
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ExpansionTile(
            key: Key(displayName),
            title: Text(displayName),
            trailing: Icon(
              _expandedDisplay == displayName
                  ? Icons.keyboard_arrow_down // Downward arrow when expanded
                  : Icons.keyboard_arrow_right, // Right arrow when collapsed
            ),
            initiallyExpanded: _expandedDisplay == displayName,
            onExpansionChanged: (expanded) {
              setState(() {
                _expandedDisplay = expanded
                    ? displayName
                    : null; // Only expand one display at a time
              });
            },
            children: timeslotsForDisplay.map((timeslot) {
              return TimeslotCard(
                timeslot: timeslot,
                onStatusChanged: () {
                  // Reload timeslot statuses after approval change
                  setState(() {
                    timeslotStatusFuture = _fetchTimeslotStatus();
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
  }
