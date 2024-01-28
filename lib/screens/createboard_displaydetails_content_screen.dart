import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/repositories/display_repository.dart';
import 'package:myboard/screens/createboard_timeslot_selector.dart';
import 'package:table_calendar/table_calendar.dart';

class DisplayDetailsDrawerContent extends StatefulWidget {
  final DisplayDetails displayDetails;
  List<String> selectedTimeSlots = [];
  DateTime? _selectedDate;
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

  double rating = 0.0;
  String comment = "";

  @override
  void initState() {
    super.initState();
    _loadDisplayImage();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display Details section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  title: Text('Display Details'),
                  automaticallyImplyLeading: false,
                ),
                ListTile(
                  title: Text(
                    'Display Name: ${widget.displayDetails.displayName}',
                  ),
                ),
              ],
            ),
            // Image section with reduced width
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
            // Ratings section
            _buildRatingsSection(),
            // Comments section
            _buildCommentsSection(),
            // Row for Calendar and additional details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Calendar'),
                      SizedBox(height: 8),
                      _buildCalendar(), // Add this line
                    ],
                  ),
                ),
                // Time Slots on the right
                Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Time Slots'),
                      SizedBox(height: 8),
                      TimeSlotSelector(
                        onTimeSelected: (degrees) {
                          String timeSlot = degrees.toString();
                          setState(() {
                            _selectedTimeSlots.add(timeSlot);
                          });
                          print('Selected degrees: $degrees');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onDateSelected(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
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

  Widget _buildAvailableTimeSlots(DateTime selectedDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Time Slots for ${DateFormat('yyyy-MM-dd').format(selectedDate)}:',
        ),
        SizedBox(height: 8),
        TimeSlotSelector(
          onTimeSelected: (degrees) {
            print('Selected degrees: $degrees');
            // Add your logic for handling the selected time
          },
        ),
        SizedBox(height: 16),
        Text(
          'Unavailable Time Slots for ${DateFormat('yyyy-MM-dd').format(selectedDate)}:',
        ),
        SizedBox(height: 8),
        // Add your unavailable time slots display here
      ],
    );
  }

  Widget _buildTimeSlotsList(List<String> timeSlots, Color color) {
    return Column(
      children: timeSlots
          .map(
            (timeSlot) => ListTile(
              title: Text(
                timeSlot,
                style: TextStyle(color: color),
              ),
            ),
          )
          .toList(),
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
