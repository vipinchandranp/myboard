import 'package:flutter/material.dart';
import '../board/view_boards.dart';
import 'timeslots.dart';

class AssociateDisplaysStepper extends StatefulWidget {
  final String displayId;

  const AssociateDisplaysStepper({Key? key, required this.displayId})
      : super(key: key);

  @override
  _AssociateDisplaysStepperState createState() =>
      _AssociateDisplaysStepperState();
}

class _AssociateDisplaysStepperState extends State<AssociateDisplaysStepper> {
  int _currentStep = 0;
  List<String> _selectedTimeSlots = [];
  List<String> _selectedBoards = [];

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _currentStep,
      onStepContinue: () async {
        if (_currentStep == 0) {
          // Navigate to TimeSlotWidget and await result when popping
          final List<String>? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TimeSlotWidget(displayId: widget.displayId),
            ),
          );
          if (result != null) {
            setState(() {
              _selectedTimeSlots = result;
              _currentStep++; // Proceed to the next step after selecting time slots
            });
          }
        } else if (_currentStep == 1) {
          // Navigate to ViewBoardsWidget and await result when popping
          final List<String>? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewBoardsWidget(),
            ),
          );
          if (result != null) {
            setState(() {
              _selectedBoards = result;
              _currentStep++; // Finish the stepper after selecting boards
            });
          }
        }
      },
      onStepCancel: () {
        if (_currentStep > 0) {
          setState(() {
            _currentStep--; // Go back one step
          });
        } else {
          Navigator.pop(context); // Exit the stepper
        }
      },
      steps: [
        Step(
          title: Text("Select Time Slots"),
          content: _selectedTimeSlots.isNotEmpty
              ? Text("Selected time slots: ${_selectedTimeSlots.join(', ')}")
              : Text("No time slots selected."),
          isActive: _currentStep >= 0,
        ),
        Step(
          title: Text("Select Boards"),
          content: _selectedBoards.isNotEmpty
              ? Text("Selected boards: ${_selectedBoards.join(', ')}")
              : Text("No boards selected."),
          isActive: _currentStep >= 1,
        ),
        Step(
          title: Text("Review and Submit"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Selected time slots: ${_selectedTimeSlots.join(', ')}"),
              Text("Selected boards: ${_selectedBoards.join(', ')}"),
            ],
          ),
          isActive: _currentStep == 2,
        ),
      ],
    );
  }
}
