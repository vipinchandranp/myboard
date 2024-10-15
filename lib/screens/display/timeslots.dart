import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../repository/display_repository.dart';
import '../board/view_boards.dart'; // Ensure this is your BoardService

class TimeSlotWidget extends StatefulWidget {
  final String displayId;

  const TimeSlotWidget({
    Key? key,
    required this.displayId,
  }) : super(key: key);

  @override
  _TimeSlotWidgetState createState() => _TimeSlotWidgetState();
}

class _TimeSlotWidgetState extends State<TimeSlotWidget> {
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();
  Set<String> selectedSlots = {};
  Future<List<Map<String, dynamic>>?>? timeSlotsFuture;

  @override
  void initState() {
    super.initState();
    timeSlotsFuture = _fetchTimeSlots();
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
              TableCalendar<DateTime>(
                focusedDay: focusedDate,
                firstDay: DateTime.now(),
                lastDay: DateTime(2101),
                selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    selectedDate = selectedDay;
                    focusedDate = focusedDay;
                    selectedSlots.clear();
                    timeSlotsFuture = _fetchTimeSlots();
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
                        final startTime = DateFormat.Hm()
                            .format(DateTime.parse(timeSlot['startTime']));
                        final endTime = DateFormat.Hm()
                            .format(DateTime.parse(timeSlot['endTime']));
                        final slotKey = '$startTime - $endTime';
                        final isSelected = selectedSlots.contains(slotKey);

                        Color tileColor;
                        if (isSelected) {
                          tileColor = Colors.lightBlue[100]!;
                        } else if (timeSlot['status'] == 'AVAILABLE') {
                          tileColor = Colors.green[100]!;
                        } else {
                          tileColor = Colors.red[100]!;
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
                                  selectedSlots.remove(slotKey);
                                } else {
                                  selectedSlots.add(slotKey);
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
                // Pass the selected date and slots back to the previous screen
                final selectedData = {
                  'displayId': widget.displayId,
                  'selectedDate': selectedDate,
                  'selectedSlots': selectedSlots.toList(),
                };

                // Return selected data and go back
                Navigator.of(context).pop(selectedData);
              },
              label: const Text("Confirm timeslot"), // Updated label
              icon: const Icon(Icons.check),
              backgroundColor: Colors.white,
            )
          : null,
    );
  }

  Future<List<Map<String, dynamic>>?> _fetchTimeSlots() async {
    final displayService = DisplayService(context);
    try {
      final timeSlots =
          await displayService.getTimeSlots(widget.displayId, selectedDate);
      return timeSlots;
    } catch (e) {
      return null;
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
