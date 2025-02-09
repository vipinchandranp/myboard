import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../repository/display_repository.dart';
import '../board/view_boards.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Time Slots"),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCalendar(theme),
              const SizedBox(height: 16),
              _buildTimeSlots(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: selectedSlots.isNotEmpty
          ? FloatingActionButton.extended(
        onPressed: () => _onConfirm(),
        label: const Text("Confirm Time Slot"),
        icon: const Icon(Icons.check),
        backgroundColor: theme.colorScheme.primary,
      )
          : null,
    );
  }

  Widget _buildCalendar(ThemeData theme) {
    return TableCalendar<DateTime>(
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
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        todayDecoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        defaultDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        weekendDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: timeSlotsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return _buildErrorMessage("Failed to fetch time slots: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildErrorMessage("No time slots available for this date.");
        }

        final timeSlots = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: timeSlots.length,
          itemBuilder: (context, index) {
            return _buildTimeSlotCard(timeSlots[index]);
          },
        );
      },
    );
  }

  Widget _buildTimeSlotCard(Map<String, dynamic> timeSlot) {
    final theme = Theme.of(context);
    final startTime = DateFormat.Hm().format(DateTime.parse(timeSlot['startTime']));
    final endTime = DateFormat.Hm().format(DateTime.parse(timeSlot['endTime']));
    final slotKey = '$startTime - $endTime';
    final isSelected = selectedSlots.contains(slotKey);

    final tileColor = isSelected
        ? theme.colorScheme.primary.withOpacity(0.2)
        : (timeSlot['status'] == 'AVAILABLE'
        ? Colors.green[100]
        : Colors.red[100]);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          slotKey,
          style: TextStyle(
            color: isSelected ? theme.colorScheme.primary : Colors.black,
          ),
        ),
        subtitle: Text('Status: ${timeSlot['status']}'),
        tileColor: tileColor,
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedSlots.remove(slotKey);
            } else if (timeSlot['status'] == 'AVAILABLE') {
              selectedSlots.add(slotKey);
            }
          });
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>?> _fetchTimeSlots() async {
    final displayService = DisplayService(context);
    try {
      return await displayService.getTimeSlots(widget.displayId, selectedDate);
    } catch (e) {
      return null;
    }
  }

  Widget _buildErrorMessage(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _onConfirm() {
    final selectedData = {
      'displayId': widget.displayId,
      'selectedDate': selectedDate,
      'selectedSlots': selectedSlots.toList(),
    };
    Navigator.of(context).pop(selectedData);
  }
}
