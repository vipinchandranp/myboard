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
import '../qrcode/show_qr_code.dart';
import 'current_board_playing.dart';

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
  bool _showCurrentlyPlaying = false; // Toggle for showing CurrentBoardPlaying
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
                    _buildBoardList(),
                    const SizedBox(height: 12),

                    // Add the displayPin here in a large font
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Pin: ${widget.display.displayPin}',
                        style: TextStyle(
                          fontSize: 32, // Large font size for the displayPin
                          fontWeight: FontWeight.bold,
                          color: Colors.blue, // Or any color of your choice
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Horizontally scrollable buttons
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          RoundedButton(
                            icon: Icons.map,
                            label: 'Show on Map',
                            onPressed: () => _showDisplayOnMap(widget.display),
                          ),
                          const SizedBox(width: 8), // Spacing between buttons
                          RoundedButton(
                            icon: Icons.qr_code,
                            label: 'Show QR Code',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowQRCode(
                                    data: widget.display.displayId,
                                    title:
                                        'QR Code for ${widget.display.displayName}',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          RoundedButton(
                            icon: _showStepper
                                ? Icons.expand_less
                                : Icons.book_online,
                            label: _showStepper ? 'Collapse' : 'Book Display',
                            onPressed: () {
                              setState(() {
                                _showStepper = !_showStepper;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    if (_showStepper) _buildStepper(),

                    const SizedBox(height: 16),

                    // Button to navigate to CurrentBoardPlayingScreen
                    RoundedButton(
                      icon: Icons.play_arrow,
                      label: 'Show Currently Playing',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CurrentBoardPlaying(
                              displayId: widget.display
                                  .displayId, // Pass displayId to CurrentBoardPlaying
                            ),
                          ),
                        );
                      },
                    ),
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<String>? boardIds = snapshot.data;

        if (boardIds == null || boardIds.isEmpty) {
          return const Text(
            'No boards associated with this display.',
            style: TextStyle(color: Colors.grey),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewBoardsWidget(
                      viewMode: ViewMode.timeslotBoardSelection,
                      boardIds: boardIds,
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
          _showStepper = false;
          _currentStep = 0;
          _selectedBoard = null;
          _selectedTimeSlots = null;
          _selectedDate = null;
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
}
