import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/models/board.dart';

class PinBoardScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final List<String> availableTimeSlots = [
    '9:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '1:00 PM - 2:00 PM',
    '2:00 PM - 3:00 PM',
    '3:00 PM - 4:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardCubit, BoardState>(
      builder: (context, state) {
        if (state is BoardLoaded) {
          final boards = state.boards;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.length < 3) {
                      return const Iterable<String>.empty();
                    }
                    final searchValue = textEditingValue.text.toLowerCase();
                    return boards
                        .map((board) => board.title)
                        .where((option) =>
                    option.toLowerCase().substring(0, 3) == searchValue)
                        .toList();
                  },
                  onSelected: (selectedTitle) {
                    _searchController.text = selectedTitle;
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                    return TextFormField(
                      controller: _searchController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: 'Search by title',
                        suffixIcon: Icon(Icons.search),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: boards.length,
                  itemBuilder: (context, index) {
                    final board = boards[index];
                    if (_searchController.text.isEmpty ||
                        board.title
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase())) {
                      return Card(
                        color: Colors.yellow.shade100,
                        child: ListTile(
                          title: Text(board.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(board.description),
                              if (board.dateTimeSlot != null)
                                Text(
                                  'Selected Date: ${board.dateTimeSlot!.date.toLocal()}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              if (board.dateTimeSlot != null)
                                Text(
                                  'Selected Time Slot: ${board.dateTimeSlot!.timeSlot}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                            ],
                          ),
                          trailing: PopupMenuButton<int>(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem<int>(
                                value: 1,
                                child: ListTile(
                                  leading: Icon(Icons.view_agenda),
                                  title: Text('View'),
                                  onTap: () {
                                    // View operation
                                  },
                                ),
                              ),
                              PopupMenuItem<int>(
                                value: 2,
                                child: ListTile(
                                  leading: Icon(Icons.calendar_today),
                                  title: Text('Select Date and Time'),
                                  onTap: () async {
                                    final selectedDateTime =
                                    await Navigator.push<DateTimeSlot>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SelectDateTimeScreen(
                                              availableTimeSlots:
                                              availableTimeSlots,
                                            ),
                                      ),
                                    );

                                    if (selectedDateTime != null) {
                                      context
                                          .read<BoardCubit>()
                                          .addDateTimeSlot(
                                          board, selectedDateTime);
                                    }
                                  },
                                ),
                              ),
                              PopupMenuItem<int>(
                                value: 3,
                                child: ListTile(
                                  leading: Icon(Icons.location_on),
                                  title: Text('Select Location'),
                                  onTap: () {
                                    // Location operation
                                  },
                                ),
                              ),
                              PopupMenuItem<int>(
                                value: 4,
                                child: ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Confirm Deletion'),
                                          content: Text(
                                              'Are you sure you want to delete this board?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Delete'),
                                              onPressed: () {
                                                context
                                                    .read<BoardCubit>()
                                                    .deleteBoard(board);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}



class SelectDateTimeScreen extends StatefulWidget {
  final List<String> availableTimeSlots;

  SelectDateTimeScreen({required this.availableTimeSlots});

  @override
  _SelectDateTimeScreenState createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  DateTime? selectedDate;
  String? selectedTimeSlot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Date and Time'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 30)),
              );

              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
            child: Text(selectedDate != null
                ? 'Selected Date: ${selectedDate!.toLocal()}'
                : 'Select Date'),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widget.availableTimeSlots.length,
              itemBuilder: (context, index) {
                final timeSlot = widget.availableTimeSlots[index];
                return ListTile(
                  title: Text(timeSlot),
                  onTap: () {
                    setState(() {
                      selectedTimeSlot = timeSlot;
                    });
                  },
                  tileColor: selectedTimeSlot == timeSlot
                      ? Colors.yellowAccent
                      : Colors.transparent,
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedDate != null && selectedTimeSlot != null) {
                Navigator.pop(
                  context,
                  DateTimeSlot(
                    date: selectedDate!,
                    timeSlot: selectedTimeSlot!,
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Missing Selection'),
                      content: Text(
                          'Please select both date and time slot before proceeding.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Text('Confirm Selection'),
          ),
        ],
      ),
    );
  }
}
