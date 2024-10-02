import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:table_calendar/table_calendar.dart'; // Import the table_calendar package
import '../../repository/display_repository.dart';
import '../board/view_boards.dart'; // Ensure this is your DisplayService

class TimeSlotWidget extends StatefulWidget {
  final String displayId;
  final BuildContext parentContext;

  const TimeSlotWidget({
    Key? key,
    required this.displayId,
    required this.parentContext,
  }) : super(key: key);

  @override
  _TimeSlotWidgetState createState() => _TimeSlotWidgetState();
}

class _TimeSlotWidgetState extends State<TimeSlotWidget> {
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate =
      DateTime.now(); // Track the focused date for the calendar
  Set<String> selectedSlots = {}; // Set to store selected time slots
  Future<List<Map<String, dynamic>>?>? timeSlotsFuture; // Adjusted future type

  @override
  void initState() {
    super.initState();
    timeSlotsFuture =
        _fetchTimeSlots(); // Fetch time slots for the initial date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Time Slots"),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Calendar widget
              TableCalendar<DateTime>(
                focusedDay: focusedDate,
                firstDay: DateTime.now(),
                lastDay: DateTime(2101),
                selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    selectedDate = selectedDay;
                    focusedDate = focusedDay; // Update focused date
                    selectedSlots
                        .clear(); // Reset selected slots when date changes
                    timeSlotsFuture =
                        _fetchTimeSlots(); // Fetch time slots for the new date
                  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  defaultDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  weekendDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Display time slots
              FutureBuilder<List<Map<String, dynamic>>?>(
                future: timeSlotsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return _buildErrorDialog(
                        "Failed to fetch time slots: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildErrorDialog(
                        "No time slots available for this date.");
                  }

                  final timeSlots = snapshot.data!;

                  return SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: timeSlots.length,
                      itemBuilder: (context, index) {
                        final timeSlot = timeSlots[index];
                        // Format startTime and endTime into readable time
                        final startTime = DateFormat.Hm()
                            .format(DateTime.parse(timeSlot['startTime']));
                        final endTime = DateFormat.Hm()
                            .format(DateTime.parse(timeSlot['endTime']));
                        final slotKey = '$startTime - $endTime';
                        final isSelected = selectedSlots
                            .contains(slotKey); // Check if slot is selected

                        Color tileColor;
                        if (isSelected) {
                          tileColor = Colors
                              .lightBlue[100]!; // Sky blue for selected slots
                        } else if (timeSlot['status'] == 'AVAILABLE') {
                          tileColor = Colors
                              .green[100]!; // Light green for available slots
                        } else {
                          tileColor = Colors
                              .red[100]!; // Light red for unavailable slots
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(slotKey),
                            subtitle: Text('Status: ${timeSlot['status']}'),
                            tileColor: tileColor,
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedSlots.remove(
                                      slotKey); // Deselect if already selected
                                } else {
                                  selectedSlots.add(slotKey); // Select the slot
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: selectedSlots.isNotEmpty
          ? FloatingActionButton.extended(
        onPressed: () async {
          // Gather the selected data to return to the parent widget
          final selectedData = {
            'displayId': widget.displayId,
            'selectedDate': selectedDate,
            'selectedSlots': selectedSlots.toList(),
          };

          // Navigate to ViewBoardsWidget to select boards
          final selectedBoards = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ViewBoardsWidget(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0); // Start from the right
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );

          // If selectedBoards is not null, save boards with time slots
          if (selectedBoards != null) {
            final displayService = DisplayService(widget.parentContext);

            // Prepare formattedBoardIds assuming selectedBoards is a list of board IDs
            final formattedBoardIds = selectedBoards;

            print('selected boards = ${selectedBoards}');

            // Prepare formattedTimeSlots directly from selectedSlots
            final formattedTimeSlots = selectedSlots.map((slotKey) {
              // Parse start and end times from slotKey
              final timeParts = slotKey.split(' - ');
              return {
                'startTime': timeParts[0], // Keep as String
                'endTime': timeParts[1]
              };
            }).toList();

            final success = await displayService.saveBoardsWithTimeSlots(
              widget.displayId,
              formattedBoardIds, // Pass the formatted board IDs
              selectedDate,
              formattedTimeSlots, // Use selected time slots
            );

            if (success) {
              // Notify the user and pop the context if saving was successful
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Time slots saved successfully!')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to save time slots.')),
              );
            }
          }

          // Return the selected data and board IDs
          Navigator.of(context).pop({
            ...selectedData,
            'selectedBoardIds': selectedBoards,
          });
        },
        label: const Text("Select boards"),
        icon: const Icon(Icons.check),
        backgroundColor: Colors.white,
      )
          : null,

    );
  }

  Future<List<Map<String, dynamic>>?> _fetchTimeSlots() async {
    final displayService = DisplayService(widget.parentContext);
    try {
      final timeSlots =
          await displayService.getTimeSlots(widget.displayId, selectedDate);
      return timeSlots; // Return timeSlots directly, as it might be null
    } catch (e) {
      // Handle error gracefully
      return null; // Return null instead of an empty list
    }
  }

  Widget _buildErrorDialog(String message) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
