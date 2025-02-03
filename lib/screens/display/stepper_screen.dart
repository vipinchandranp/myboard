import 'package:flutter/material.dart';
import 'package:myboard/models/display/bdisplay.dart';
import 'package:myboard/screens/display/selected_board.dart';
import 'package:myboard/screens/display/selected_time_slot_section.dart';
import 'package:myboard/screens/display/timeslots.dart';
import '../../models/board/board.dart';
import '../../repository/display_repository.dart';
import '../../utils/view_mode.dart';
import '../../widgets/round_button.dart';
import '../board/view_boards.dart';
class StepperScreen extends StatefulWidget {
  final BDisplay display;

  const StepperScreen({Key? key, required this.display}) : super(key: key);

  @override
  _StepperScreenState createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  DateTime? _selectedDate;
  List<String>? _selectedTimeSlots;
  Board? _selectedBoard;
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Display: ${widget.display.displayName}'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        steps: [
          Step(
            title: const Text('Select Time Slot'),
            content: Column(
              children: [
                SelectedTimeSlotSectionWidget(
                  selectedDate: _selectedDate,
                  selectedTimeSlots: _selectedTimeSlots,
                ),
                ElevatedButton(
                  onPressed: _showBookingDialog,
                  child: const Text('Select Time Slots'),
                ),
              ],
            ),
            isActive: _currentStep == 0,
          ),
          Step(
            title: const Text('Select Board'),
            content: Column(
              children: [
                RoundedButton(
                  icon: Icons.dashboard,
                  label: 'Select Board',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ViewBoardsWidget(viewMode: ViewMode.timeslotBoardSelection),
                      ),
                    ).then((selectedBoard) {
                      if (selectedBoard != null) {
                        setState(() {
                          _selectedBoard = selectedBoard;
                        });
                      }
                    });
                  },
                ),
                if (_selectedBoard != null) SelectedBoardWidget(selectedBoard: _selectedBoard),
              ],
            ),
            isActive: _currentStep == 1,
          ),
          Step(
            title: const Text('Save Selections'),
            content: ElevatedButton(
              onPressed: _saveSelections,
              child: const Text('Save'),
            ),
            isActive: _currentStep == 2,
          ),
        ],
      ),
    );
  }

  // Methods to handle steps
  void _onStepContinue() {
    setState(() {
      if (_currentStep < 2) {
        _currentStep++;
      }
    });
  }

  void _onStepCancel() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  void _showBookingDialog() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeSlotWidget(displayId: widget.display.displayId),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedDate = result['selectedDate'];
        _selectedTimeSlots = result['selectedSlots'];
      });
    }
  }

  void _saveSelections() async {
    if (_selectedBoard == null || _selectedTimeSlots == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all steps before saving.')),
      );
      return;
    }

    // Prepare the time slots
    List<Map<String, String>> timeSlots = _selectedTimeSlots!.map((slot) {
      var times = slot.split(' - ');
      return {
        'startTime': times[0].trim(),
        'endTime': times[1].trim(),
        'status': 'active',
      };
    }).toList();

    try {
      // Save the selections
      bool success = await DisplayService(context).saveBoardsWithTimeSlots(
        displayId: widget.display.displayId,
        boardIds: [_selectedBoard!.boardId],
        date: _selectedDate!,
        timeSlots: timeSlots,
      );

      if (success) {
        setState(() {
          _currentStep = 0;
          _selectedBoard = null;
          _selectedTimeSlots = null;
          _selectedDate = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selected board and time slots saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save selected board and time slots.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving selections: $e')),
      );
    }
  }
}
