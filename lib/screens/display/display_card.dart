import 'package:flutter/material.dart';
import 'package:myboard/repository/display_repository.dart';
import 'package:myboard/screens/display/selected_board.dart'; // Import the new widget
import 'package:myboard/screens/display/timeslots.dart';
import 'package:myboard/models/display/bdisplay.dart';
import 'package:myboard/screens/display/media_carousel.dart';
import 'package:myboard/screens/display/selected_time_slot_section.dart';
import 'package:myboard/screens/display/status_indicator.dart';
import 'package:myboard/utils/view_mode.dart';
import 'package:myboard/screens/display/show_display_on_map.dart';
import '../../models/board/board.dart';
import '../../utils/utility.dart';
import '../../widgets/round_button.dart';
import '../board/view_boards.dart';

class DisplayCardWidget extends StatefulWidget {
  final BDisplay display;

  const DisplayCardWidget({Key? key, required this.display}) : super(key: key);

  @override
  _DisplayCardWidgetState createState() => _DisplayCardWidgetState();
}

class _DisplayCardWidgetState extends State<DisplayCardWidget> {
  DateTime? _selectedDate;
  List<String>? _selectedTimeSlots;
  Board? _selectedBoard;
  int _currentStep = 0; // Valid step index to prevent assertion error
  bool _showStepper = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              MediaCarouselWidget(display: widget.display),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.display.displayName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    StatusIndicatorWidget(status: widget.display.status),
                    const SizedBox(height: 6),
                    Text(
                      'Created on: ${Utility.formatDate(widget.display.createdDateAndTime)}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 12),
                    // Call to _buildBoardList to display associated boards
                    _buildBoardList(),
                    const SizedBox(height: 12),
                    // Call to _showDisplayOnMap with the current display object
                    RoundedButton(
                      icon: Icons.map,
                      label: 'Show on Map',
                      onPressed: () => _showDisplayOnMap(widget.display),
                    ),
                    const SizedBox(height: 12),
                    RoundedButton(
                      icon:
                          _showStepper ? Icons.expand_less : Icons.book_online,
                      // Change icon based on state
                      label: _showStepper ? 'Collapse' : 'Book Display',
                      // Change label
                      onPressed: () {
                        setState(() {
                          _showStepper =
                              !_showStepper; // Toggle stepper visibility
                        });
                      },
                    ),
                    if (_showStepper) _buildStepper(),
                    // Show Stepper widget when _showStepper is true
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Stepper Widget
  Widget _buildStepper() {
    return Stepper(
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
              _buildSelectBoardButton(),
              if (_selectedBoard != null) _buildSelectedBoardSection(),
              // Show selected board if it's not null
            ],
          ),
          isActive: _currentStep == 1,
        ),
        Step(
          title: const Text('Save Selections'),
          content: Column(
            children: [
              if (_selectedBoard != null &&
                  _selectedTimeSlots != null &&
                  _selectedDate != null)
                ElevatedButton(
                  onPressed: _saveSelectedBoard,
                  child: const Text('Save Selections'),
                ),
              if (_selectedBoard == null ||
                  _selectedTimeSlots == null ||
                  _selectedDate == null)
                const Text('Please select all fields before saving.'),
            ],
          ),
          isActive: _currentStep == 2,
        ),
      ],
    );
  }

  // Handle when user continues to the next step
  void _onStepContinue() {
    setState(() {
      if (_currentStep < 2) {
        _currentStep++;
      }
    });
  }

  void _showDisplayOnMap(BDisplay display) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowDisplayOnMap(display: display),
      ),
    );
  }

  // Handle when user cancels and goes back to the previous step
  void _onStepCancel() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  // Show the time slot selection dialog
  void _showBookingDialog() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TimeSlotWidget(displayId: widget.display.displayId),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedDate = result['selectedDate'];
        _selectedTimeSlots = result['selectedSlots'];
      });
    }
  }

  // Show the board selection button
  Widget _buildSelectBoardButton() {
    return RoundedButton(
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
    );
  }

// Build the board list section
  Widget _buildBoardList() {
    // Return a FutureBuilder to handle the async data
    return FutureBuilder<List<String>?>(
      future: DisplayService(context)
          .getBoardIdsByDisplayId(widget.display.displayId),
      builder: (BuildContext context, AsyncSnapshot<List<String>?> snapshot) {
        // Check if the future is still loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Display a loading indicator
        }

        // If the future has completed but with an error
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // If the future completed successfully
        List<String>? boardIds = snapshot.data;

        // If no boards are associated with the display
        if (boardIds == null || boardIds.isEmpty) {
          return const Text(
            'No boards associated with this display.',
            style: TextStyle(color: Colors.grey),
          );
        }

        // If there are boards, show a list with an option to view boards
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Navigate to ViewBoardsWidget and pass the boardIds
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewBoardsWidget(
                      viewMode: ViewMode.timeslotBoardSelection,
                      boardIds: boardIds, // Pass the boardIds here
                    ),
                  ),
                );
              },
              child: Text(
                '${boardIds.length} boards associated',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Build the selected board section
  Widget _buildSelectedBoardSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selected Board:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          SelectedBoardWidget(selectedBoard: _selectedBoard),
          // Using the widget
        ],
      ),
    );
  }

  // Save selected board and time slots
  void _saveSelectedBoard() async {
    if (_selectedBoard != null &&
        _selectedTimeSlots != null &&
        _selectedDate != null) {
      List<Map<String, String>> timeSlots = _selectedTimeSlots!.map((slot) {
        var times = slot.split(' - ');
        return {
          'startTime': times[0].trim(),
          'endTime': times[1].trim(),
          'status': 'active',
        };
      }).toList();

      bool success = await DisplayService(context).saveBoardsWithTimeSlots(
        displayId: widget.display.displayId,
        boardIds: [_selectedBoard!.boardId],
        date: _selectedDate!,
        timeSlots: timeSlots,
      );

      if (success) {
        setState(() {
          _showStepper = false; // Collapse stepper after successful save
          _currentStep = 0; // Reset the stepper to the first step
          _selectedBoard = null; // Reset the selected board
          _selectedTimeSlots = null; // Reset the selected time slots
          _selectedDate = null; // Reset the selected date
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Selected board and time slots saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to save selected board and time slots.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please select a board and time slots before saving.')),
      );
    }
  }

  void _showBottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
