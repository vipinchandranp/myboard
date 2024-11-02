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
  Board? _selectedBoard;
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
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
      color: _isSelected ? Colors.blue[50] : Colors.white,
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
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors
                                .black87, // Set the color to a visible one
                          ),
                          onPressed: () {
                            _showBottomSheetMenu(context);
                          },
                          iconSize: 28,
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

  void _saveSelectedBoard() async {
    if (_selectedBoard != null &&
        _selectedTimeSlots != null &&
        _selectedDate != null) {
      List<Map<String, String>> timeSlots = _selectedTimeSlots!.map((slot) {
        var times = slot.split(' - ');
        return {
          'startTime': times[0].trim(),
          'endTime': times[1].trim(),
          'status': 'active'
        };
      }).toList();

      bool success = await DisplayService(context).saveBoardsWithTimeSlots(
        displayId: widget.display.displayId,
        boardIds: [_selectedBoard!.boardId],
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
                leading: const Icon(Icons.book),
                title: const Text('Book'),
                onTap: () {
                  Navigator.pop(context); // Close the BottomSheet
                  _showBookingDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context); // Close the BottomSheet
                  _showEditDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context); // Close the BottomSheet
                  _showDeleteConfirmation(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
