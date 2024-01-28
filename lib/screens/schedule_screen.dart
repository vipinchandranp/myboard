import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:myboard/bloc/user/user_cubit.dart';
import 'package:myboard/models/board.dart';
import 'package:intl/intl.dart';
import 'package:myboard/repositories/board_repository.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ScheduleScreen extends StatefulWidget {
  final Function(DateTimeSlot) onConfirm;
  BuildContext context;

  ScheduleScreen({
    required this.onConfirm,
    required this.context
  });

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState(context);
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late DateTime selectedDate;
  late TimeOfDay selectedStartTime;
  late TimeOfDay selectedEndTime;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _displayController = TextEditingController();
  List<String>? availableUsernames = [];
  List<String>? availableDisplays = [];
  late BuildContext _context;
  _ScheduleScreenState(BuildContext context){
    _context = context;
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedStartTime = TimeOfDay.now();
    selectedEndTime = selectedStartTime.replacing(hour: selectedStartTime.hour);

  }


  Future<Iterable<String>> fetchAvailableUsernames(String pattern) async {
    try {
      final UserCubit userCubit = context.read<UserCubit>();
      List<String> userList = await userCubit.getAvailableUsers(pattern);
      return userList;
    } catch (error) {
      // Handle errors here (inside the async function)
      // The code inside this block is executed if the Future throws an error.
      return [];
    }
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
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Date and Time'),
        ),
        body: Container(
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.9, // Set width to 60% of the screen
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        title: Text('Date'),
                        subtitle:
                            Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
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
                      SizedBox(height: 16.0),
                      ListTile(
                        title: Text('Username'),
                        subtitle: Builder(builder: (context) {
                          final userCubit = context.watch<UserCubit>();
                          return TypeAheadField<String>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                hintText: 'Enter a username',
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return await userCubit.getAvailableUsers(pattern);
                            },
                            itemBuilder: (context, username) {
                              return ListTile(
                                title: Text(username),
                              );
                            },
                            onSuggestionSelected: (username) {
                              _onUsernameSelected(username);
                            },
                          );
                        }),
                      ),
                      SizedBox(height: 16.0),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final dateTimeSlot = DateTimeSlot(
                                selectedDate: selectedDate,
                                startTime: selectedStartTime,
                                endTime: selectedEndTime,
                              );
                              widget.onConfirm(dateTimeSlot);
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(Size(40,
                                  40)), // Set the minimum size of the button
                            ),
                            child: Text('Confirm'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
