import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/models/board.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/models/board.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/models/board.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/models/board.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/models/board.dart';

class ScheduleScreen extends StatefulWidget {
  final Function(DateTimeSlot) onConfirm;
  final List<String> availableDisplays;

  ScheduleScreen({
    required this.onConfirm,
    required this.availableDisplays,
  });

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late DateTime selectedDate;
  late TimeOfDay selectedStartTime;
  late TimeOfDay selectedEndTime;
  late String selectedDisplay;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedStartTime = TimeOfDay.now();
    selectedEndTime =
        selectedStartTime.replacing(hour: selectedStartTime.hour + 1);
    selectedDisplay = widget.availableDisplays.first; // Initialize with the first item
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
        selectedEndTime = pickedTime.replacing(hour: pickedTime.hour + 1);
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
      selectedDisplay = display;
    });
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
            subtitle: Text('${selectedDate.toLocal()}'),
            onTap: () => _selectDate(context),
          ),
          ListTile(
            title: Text('Start Time'),
            subtitle: Text('${selectedStartTime.format(context)}'),
            onTap: () => _selectStartTime(context),
          ),
          ListTile(
            title: Text('End Time'),
            subtitle: Text('${selectedEndTime.format(context)}'),
            onTap: () => _selectEndTime(context),
          ),
          ListTile(
            title: Text('Display'),
            subtitle: DropdownButton<String>(
              value: selectedDisplay,
              items: widget.availableDisplays.map((display) {
                return DropdownMenuItem<String>(
                  value: display,
                  child: Text(display),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  _onDisplaySelected(value);
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final dateTimeSlot = DateTimeSlot(
                date: selectedDate,
                startTime: selectedStartTime,
                endTime: selectedEndTime,
                display: selectedDisplay,
              );
              widget.onConfirm(dateTimeSlot);
              Navigator.pop(context); // Navigate back to the previous screen (PinBoardScreen)
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
