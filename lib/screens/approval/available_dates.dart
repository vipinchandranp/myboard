import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../repository/approval_repository.dart';
import 'my_approval.dart';

class AvailableDatesWidget extends StatefulWidget {
  @override
  _AvailableDatesWidgetState createState() => _AvailableDatesWidgetState();
}

class _AvailableDatesWidgetState extends State<AvailableDatesWidget> {
  late Future<List<DateTime>?> availableDatesFuture; // Keep it nullable
  DateTime selectedDay = DateTime.now(); // Initialize selectedDay
  List<DateTime> availableDates = []; // List to hold available dates

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch available dates
    availableDatesFuture = ApprovalService(context).fetchAvailableDates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Dates'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<DateTime>?>(
        future: availableDatesFuture, // Future for available dates
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error state
          } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No available dates found.')); // Empty state
          } else {
            availableDates = snapshot.data!; // Assign available dates

            // Debug print to check available dates
            print('Available Dates: $availableDates');

            return Column(
              children: [
                TableCalendar<DateTime>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: selectedDay,
                  selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      this.selectedDay = selectedDay; // Update selected day
                    });
                    // Show MyApprovalWidget as a bottom sheet with the selected date
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent, // Make background transparent
                      builder: (context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.75, // Set height to 75% of device height
                          decoration: BoxDecoration(
                            color: Colors.white, // Bottom sheet background color
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // Rounded top corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 5,
                                offset: Offset(0, -2), // Shadow effect
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 4, // Height of the top border line
                                color: Colors.teal[300], // Color of the top border line
                                width: double.infinity, // Full width
                              ),
                              Expanded(
                                child: MyApprovalWidget(selectedDate: selectedDay), // Pass selected date here
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      // Normalize the day to ignore time for comparison
                      final isAvailable = availableDates.any((availableDate) =>
                          isSameDay(availableDate, day));

                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: isAvailable ? Colors.teal[300] : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(child: Text('${day.day}')),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
