import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/models/tileslotavailability.dart';
import 'package:myboard/repositories/display_repository.dart';
import 'package:myboard/screens/board/create_board/createboard_timeslot_selector.dart';
import 'package:table_calendar/table_calendar.dart';

class DisplayDetailsDrawerContent extends StatefulWidget {
  final DisplayDetails displayDetails;
  final Function(DateTime?, List<String>?) onDateTimeSelected;

  DisplayDetailsDrawerContent(
      {required this.displayDetails, required this.onDateTimeSelected});

  @override
  _DisplayDetailsDrawerContentState createState() =>
      _DisplayDetailsDrawerContentState();
}

class _DisplayDetailsDrawerContentState
    extends State<DisplayDetailsDrawerContent> {
  late List<int> _displayImageBytes = [];
  late List<String> _selectedTimeSlots = [];
  DateTime? _selectedDate;
  TimeSlotAvailability? _timeSlotAvailability;
  double rating = 0.0;
  String comment = "";

  @override
  void initState() {
    super.initState();
    _loadDisplayImage();

    // Set the initial selected date to the current date
    // Set the initial selected date to the current date with time set to midnight
    _selectedDate = DateTime.now().toLocal().subtract(Duration(
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
        seconds: DateTime.now().second));

    // Load time slots for the initial selected date (current date)
    _loadTimeSlotsForDate(_selectedDate!);
  }

  Future<void> _loadDisplayImage() async {
    try {
      final List<int> imageBytes =
          await DisplayRepository().getDisplayImage(widget.displayDetails.id);
      setState(() {
        _displayImageBytes = imageBytes;
      });
    } catch (e) {
      print('Error loading display image: $e');
      // Handle error loading image
    }
  }

  Future<void> _loadTimeSlotsForDate(DateTime selectedDate) async {
    try {
      // Set the time part of the selected date to midnight
      DateTime selectedDateMidnight = selectedDate.toLocal().subtract(Duration(
            hours: selectedDate.hour,
            minutes: selectedDate.minute,
            seconds: selectedDate.second,
          ));

      // Call the DisplayRepository method to get time slots for the selected date
      final TimeSlotAvailability? timeSlotAvailability =
          await DisplayRepository().getDisplayTimeSlots(
        widget.displayDetails.id,
        selectedDateMidnight,
      );

      setState(() {
        _timeSlotAvailability = timeSlotAvailability;
        _selectedTimeSlots = []; // Clear selected time slots when date changes
      });
    } catch (e) {
      print('Error loading time slots: $e');
      // Handle error loading time slots
      // For example, you can show a snackbar or dialog to inform the user about the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading time slots. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Display Details'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ),
    body: ListView(
      children: [
        _buildDisplayDetailsSection(),
        _buildImageSection(),
        _buildRatingsSection(),
        _buildCommentsSection(),
        _buildCalendarSection(),
        _buildTimeSlotsSection(),
      ],
    ),
  );
}
Widget _buildTimeSlotsSection() {
  return Card(
    margin: EdgeInsets.all(8.0),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time Slots',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          Divider(),
          _timeSlotAvailability != null
              ? _buildAvailableTimeSlots(_timeSlotAvailability!)
              : CircularProgressIndicator(),
        ],
      ),
    ),
  );
}
Widget _buildCalendarSection() {
  return Card(
    margin: EdgeInsets.all(8.0),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calendar',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          Divider(),
          _buildCalendar(),
        ],
      ),
    ),
  );
}
Widget _buildImageSection() {
  return Card(
    margin: EdgeInsets.all(8.0),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Display Image',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            width: MediaQuery.of(context).size.width - 32,
            child: _displayImageBytes.isNotEmpty
                ? Image.memory(
                    Uint8List.fromList(_displayImageBytes),
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Container(),
          ),
        ],
      ),
    ),
  );
}
Widget _buildDisplayDetailsSection() {
  return Card(
    margin: EdgeInsets.all(8.0),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Display Name',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          Divider(),
          Text(
            '${widget.displayDetails.displayName}',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    ),
  );
}
  void _onDateSelected(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });

    // Load time slots for the selected date
    _loadTimeSlotsForDate(selectedDate);

    widget.onDateTimeSelected(selectedDate, _selectedTimeSlots);
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.now().subtract(Duration(days: 365)),
      focusedDay: DateTime.now(),
      lastDay: DateTime.now().add(Duration(days: 365)),
      availableGestures: AvailableGestures.all,
      calendarFormat: CalendarFormat.month,
      calendarStyle: CalendarStyle(
        todayTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          color: Colors.blue,
        ),
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
      ),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDate, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDate = selectedDay;
        });
        _onDateSelected(selectedDay);
      },
    );
  }

  Widget _buildAvailableTimeSlots(TimeSlotAvailability timeSlotAvailability) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Slots for ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}:',
        ),
        SizedBox(height: 8),
        Column(
          children: [
            TimeSlotSelector(
              availableTimeSlots: timeSlotAvailability.availableTimeSlots,
              bookedTimeslots: timeSlotAvailability.bookedTimeslots,
              selectedTimeSlots: _selectedTimeSlots,
              onTimeSelected: (selectedTimeSlots) {
                setState(() {
                  _selectedTimeSlots = selectedTimeSlots;
                });
                widget.onDateTimeSelected(_selectedDate, _selectedTimeSlots);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingsSection() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ratings',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              RatingBar.builder(
                initialRating: rating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 24.0,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  setState(() {
                    rating = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comments',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'Add a comment...',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                comment = value;
              });
            },
          ),
        ],
      ),
    );
  }

}
