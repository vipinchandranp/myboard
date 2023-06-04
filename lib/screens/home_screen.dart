import 'package:flutter/material.dart';
import 'package:myboard/screens/ad_creation_screen.dart';
import 'package:myboard/screens/login_screen.dart';
import 'package:myboard/screens/play_screen.dart';
import 'package:myboard/screens/profile_screen.dart';
import 'package:myboard/screens/settings_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:time_slot/time_slot_from_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<AdItem> adItems = [];

  @override
  void initState() {
    super.initState();
    adItems.addAll(generateSampleItems(DateTime.now(), 6));
    adItems.addAll(generateSampleItems(DateTime.now().add(Duration(days: 1)), 23));
  }

  List<AdItem> generateSampleItems(DateTime date, int count) {
    final List<AdItem> samples = [];
    for (int i = 1; i <= count; i++) {
      samples.add(
        AdItem(
          userName: 'User $i',
          description: 'Sample Ad $i',
          rating: i % 5 + 1,
          timeSlot: date,
          status: AdStatus.Pending,
          isEnabled: true,
        ),
      );
    }
    return samples;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Image.asset('../assets/myboard_logo1.png'),
        actions: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Handle search button pressed
                      // Add your logic here
                    },
                    icon: Icon(Icons.search, color: Colors.teal),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle button pressed
                      // Add your logic here
                    },
                    icon: Icon(Icons.shopping_cart, color: Colors.teal),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle button pressed
                      // Add your logic here
                    },
                    icon: Icon(Icons.notifications, color: Colors.teal),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle button pressed
                      // Add your logic here
                    },
                    icon: Icon(Icons.settings, color: Colors.teal),
                  ),
                  // Add more icons as needed
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2022),
            lastDay: DateTime.utc(2025),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          SizedBox(height: 16.0),
          TimesSlotGridViewFromList(
            locale: "en",
            // Replace with the desired locale
            initTime: DateTime.now(),
            crossAxisCount: 4,
            listDates: adItems
                .where((adItem) => isSameDay(adItem.timeSlot, _selectedDay))
                .map((adItem) => adItem.timeSlot)
                .toList(),
            onChange: (value) {
              setState(() {
                _selectedDay = value;
              });
            },
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                // Handle play button pressed
                // Add your logic here
              },
              child: Icon(Icons.play_arrow),
            ),
          ),
        ],
      ),
    );
  }
}


class ExpandableCard extends StatefulWidget {
  final AdItem adItem;

  ExpandableCard({required this.adItem});

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.menu),
                SizedBox(width: 8.0),
                Text(widget.adItem.userName),
              ],
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                // Handle menu button pressed
                // Add your logic here
              },
            ),
          ],
        ),
        leading: _isExpanded
            ? Icon(Icons.keyboard_arrow_up)
            : Icon(Icons.keyboard_arrow_down),
        onExpansionChanged: (value) {
          setState(() {
            _isExpanded = value;
          });
        },
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.play_arrow),
                SizedBox(width: 8.0),
                Text(widget.adItem.description),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(
                Icons.star,
                color: widget.adItem.rating >= 1 ? Colors.yellow : Colors.grey,
              ),
              Icon(
                Icons.star,
                color: widget.adItem.rating >= 2 ? Colors.yellow : Colors.grey,
              ),
              Icon(
                Icons.star,
                color: widget.adItem.rating >= 3 ? Colors.yellow : Colors.grey,
              ),
              Icon(
                Icons.star,
                color: widget.adItem.rating >= 4 ? Colors.yellow : Colors.grey,
              ),
              Icon(
                Icons.star,
                color: widget.adItem.rating >= 5 ? Colors.yellow : Colors.grey,
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text('Time Slot: ${widget.adItem.timeSlot}'),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              // Preview button pressed
              // Add your logic here
            },
            child: Text('Preview'),
          ),
        ],
      ),
    );
  }
}

class AdItem {
  final String userName;
  final String description;
  final int rating;
  final DateTime timeSlot;
  final bool isEnabled;
  final AdStatus status;

  AdItem({
    required this.userName,
    required this.description,
    required this.rating,
    required this.timeSlot,
    required this.isEnabled,
    required this.status,
  });
}

enum AdStatus {
  Pending,
  Accepted,
  Rejected,
}
