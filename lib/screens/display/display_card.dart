import 'package:flutter/material.dart';
import 'package:myboard/repository/display_repository.dart';
import 'package:myboard/screens/display/selected_board.dart';
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
  final bool isSelected;

  const DisplayCardWidget(
      {Key? key, required this.display, this.isSelected = false})
      : super(key: key);

  @override
  _DisplayCardWidgetState createState() => _DisplayCardWidgetState();
}

class _DisplayCardWidgetState extends State<DisplayCardWidget> {
  bool _isSelected = false;
  DateTime? _selectedDate;
  List<String>? _selectedTimeSlots;
  Board? _selectedBoard; // Stores selected board object
  bool _showSelectBoardButton = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: _isSelected ? Colors.blue[100] : Colors.white,
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
                        // Map icon positioned next to the display name
                        IconButton(
                          icon: const Icon(Icons.map),
                          tooltip: 'Show on Map',
                          onPressed: () {
                            _showDisplayOnMap(widget.display);
                          },
                          color: Colors.blue,
                          iconSize: 30,
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            switch (value) {
                              case 'book':
                                _showBookingDialog(context);
                                break;
                              case 'edit':
                                _showEditDialog(context);
                                break;
                              case 'delete':
                                _showDeleteConfirmation(context);
                                break;
                              default:
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem<String>(
                                value: 'book',
                                child: Text('Book'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ];
                          },
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
                    _buildBoardList(widget.display.boardIds),
                    SelectedTimeSlotSectionWidget(
                        selectedDate: _selectedDate,
                        selectedTimeSlots: _selectedTimeSlots),
                    const SizedBox(height: 12),
                    if (_showSelectBoardButton) _buildSelectBoardButton(),
                    // Show the selected board if available
                    if (_selectedBoard != null)
                      SelectedBoardWidget(selectedBoard: _selectedBoard),
                    // Pass Board instance

                    // Save Button
                    if (_selectedBoard != null) _buildSaveButton(),
                    // Show save button when a board is selected
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Checkbox(
              value: _isSelected,
              onChanged: (value) {
                setState(() {
                  _isSelected = value ?? false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDisplayOnMap(BDisplay display) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowDisplayOnMap(display: display),
      ),
    );
  }

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
          // Update the state with the selected board
          if (selectedBoard != null) {
            setState(() {
              _selectedBoard = selectedBoard; // Set the selected board
              _showSelectBoardButton = false; // Hide the button after selection
            });
          }
        });
      },
    );
  }

  void _showBookingDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TimeSlotWidget(displayId: widget.display.displayId),
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          _selectedDate = result['selectedDate'];
          _selectedTimeSlots = result['selectedSlots'];
          _showSelectBoardButton = true; // Show the Select Board button
        });
      }
    });
  }

  void _showEditDialog(BuildContext context) {
    // Implement your edit dialog or navigation here
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Display'),
          content: const Text('Are you sure you want to delete this display?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement delete logic here
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBoardList(List<String> boardIds) {
    if (boardIds.isEmpty) {
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
  }

  // Method to build the Save button
  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: ElevatedButton(
        onPressed: () {
          _saveSelectedBoard();
        },
        child: const Text('Save Selected Board'),
      ),
    );
  }

// Method to handle save action
// Method to handle save action
  void _saveSelectedBoard() async {
    if (_selectedBoard != null &&
        _selectedTimeSlots != null &&
        _selectedDate != null) {
      // Create a list of time slots with necessary data structure
      List<Map<String, String>> timeSlots = _selectedTimeSlots!.map((slot) {
        // Split the slot into start and end times based on your format
        var times = slot.split(' - ');
        return {
          'startTime': times[0].trim(), // Use the first time as startTime
          'endTime': times[1].trim(), // Use the second time as endTime
          'status': 'active' // Example status
        };
      }).toList();

      // Call saveBoardsWithTimeSlots
      bool success = await DisplayService(context).saveBoardsWithTimeSlots(
        displayId: widget.display.displayId,
        boardIds: [_selectedBoard!.boardId],
        // Assuming _selectedBoard has an id property
        date: _selectedDate!,
        timeSlots: timeSlots,
      );

      if (success) {
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
