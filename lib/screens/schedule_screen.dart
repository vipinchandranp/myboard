import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:myboard/models/board.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  final Function(DateTimeSlot) onConfirm;

  ScheduleScreen({
    required this.onConfirm,
  });

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late DateTime selectedDate;
  late TimeOfDay selectedStartTime;
  late TimeOfDay selectedEndTime;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _displayController = TextEditingController();
  List<String>? availableUsernames = [];
  List<String>? availableDisplays = [];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedStartTime = TimeOfDay.now();
    selectedEndTime = selectedStartTime.replacing(hour: selectedStartTime.hour);

    // Load the available usernames during initialization
    loadAvailableUsernames();
  }

  Future<void> loadAvailableUsernames() async {
    // Make an API call to fetch the list of available usernames
    // For example:
    // final usernames = await yourApiService.getAvailableUsernames();
    // setState(() {
    //   availableUsernames = usernames;
    // });

    // Placeholder code to demonstrate the functionality
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      availableUsernames = ['user1', 'user2', 'user3'];
    });
  }

  Future<void> fetchDisplaysForUsername(String username) async {
    // Make an API call to fetch the displays for the selected username
    // For example:
    // final displays = await yourApiService.getDisplaysForUsername(username);
    // setState(() {
    //   availableDisplays = displays;
    // });

    // Placeholder code to demonstrate the functionality
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      availableDisplays = ['Display1', 'Display2', 'Display3'];
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (pickedTime != null && pickedTime != selectedStartTime) {
      setState(() {
        selectedStartTime = pickedTime;
        selectedEndTime = pickedTime.replacing(hour: pickedTime.hour);
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );
    if (pickedTime != null && pickedTime != selectedEndTime) {
      setState(() {
        selectedEndTime = pickedTime;
      });
    }
  }

  void _onDisplaySelected(String display) {
    setState(() {
      _displayController.text = display;
    });
  }

  void _onUsernameSelected(String username) {
    setState(() {
      _usernameController.text = username;
    });

    // Fetch the displays for the selected username
    fetchDisplaysForUsername(username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Date and Time'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Date'),
            subtitle: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
            onTap: () => _selectDate(context),
          ),
          ListTile(
            title: Text('Start Time'),
            subtitle: Text(selectedStartTime.format(context)),
            onTap: () => _selectStartTime(context),
          ),
          ListTile(
            title: Text('End Time'),
            subtitle: Text(selectedEndTime.format(context)),
            onTap: () => _selectEndTime(context),
          ),
          ListTile(
            title: Text('Display'),
            subtitle: TypeAheadField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _displayController,
                decoration: InputDecoration(
                  hintText: 'Enter a display',
                ),
              ),
              suggestionsCallback: (pattern) {
                return availableDisplays
                    ?.where((display) =>
                    display.toLowerCase().contains(pattern.toLowerCase()))
                    .toList() ?? [];
              },
              itemBuilder: (context, username) {
                return ListTile(
                  title: Text(username),
                );
              },
              onSuggestionSelected: (username) {
                _onUsernameSelected(username);
              },
            ),
          ),
          ListTile(
            title: Text('Username'),
            subtitle: TypeAheadField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Enter a username',
                ),
              ),
              suggestionsCallback: (pattern) {
                return availableUsernames
                    ?.where((username) =>
                    username.toLowerCase().contains(pattern.toLowerCase()))
                    .toList() ?? [];
              },
              itemBuilder: (context, username) {
                return ListTile(
                  title: Text(username),
                );
              },
              onSuggestionSelected: (username) {
                _onUsernameSelected(username);
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final dateTimeSlot = DateTimeSlot(
                date: selectedDate,
                startTime: selectedStartTime,
                endTime: selectedEndTime,
                display: _displayController.text,
                username: _usernameController.text,
              );
              widget.onConfirm(dateTimeSlot);
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
