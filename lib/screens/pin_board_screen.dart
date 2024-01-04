import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/screens/schedule_screen.dart';

class PinBoardScreen extends StatefulWidget {
  @override
  _PinBoardScreenState createState() => _PinBoardScreenState();
}

class _PinBoardScreenState extends State<PinBoardScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Timer _timer;
  Board? selectedBoard;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<BoardCubit>().fetchBoardItems();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      // Update countdown logic here
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _selectPreviousItem();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _selectNextItem();
      }
    }
  }

  void _selectPreviousItem() {
    if (selectedBoard == null) {
      setState(() {
        selectedBoard = context.read<BoardCubit>().boards.last;
      });
    } else {
      final index = context.read<BoardCubit>().boards.indexOf(selectedBoard!);
      if (index > 0) {
        setState(() {
          selectedBoard = context.read<BoardCubit>().boards[index - 1];
        });
      }
    }
  }

  void _selectNextItem() {
    if (selectedBoard == null) {
      setState(() {
        selectedBoard = context.read<BoardCubit>().boards.first;
      });
    } else {
      final index = context.read<BoardCubit>().boards.indexOf(selectedBoard!);
      if (index < context.read<BoardCubit>().boards.length - 1) {
        setState(() {
          selectedBoard = context.read<BoardCubit>().boards[index + 1];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _handleKeyPress,
      child: BlocConsumer<BoardCubit, BoardState>(
        listener: (context, state) {
          // Handle state changes if needed
        },
        builder: (context, state) {
          if (state is BoardLoaded) {
            final List<Board> boards = state.boards;

            return Scaffold(
              body: Row(
                children: [
                  // Left side - Sidebar with the list of items
                  Container(
                    width: 250.0,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey.shade300),
                      ),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey.shade200],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: boards.length,
                            itemBuilder: (context, index) {
                              final Board board = boards[index];
                              return Focus(
                                onFocusChange: (hasFocus) {
                                  if (hasFocus) {
                                    setState(() {
                                      selectedBoard = board;
                                    });
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    color: selectedBoard == board
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: selectedBoard == board
                                        ? [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(0, 3),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: ListTile(
                                    title: Text(board.title ?? ''),
                                    onTap: () {
                                      setState(() {
                                        selectedBoard = board;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right side - Main content area for details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: selectedBoard != null
                          ? Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedBoard!.title ?? '',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      selectedBoard!.description ?? '',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    SizedBox(height: 20.0),
                                    if (selectedBoard!.displayDetails != null)
                                      for (var entry
                                          in selectedBoard!.displayDetails!)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                selectedBoard!.isApproved ??
                                                        false
                                                    ? Icons.thumb_up
                                                    : Icons.thumb_down,
                                                color:
                                                    selectedBoard!.isApproved ??
                                                            false
                                                        ? Colors.green
                                                        : Colors.red,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  selectedBoard!.isApproved =
                                                      !(selectedBoard!
                                                              .isApproved ??
                                                          false);
                                                });
                                              },
                                            ),
                                            Text(
                                              selectedBoard!.isApproved ?? false
                                                  ? 'Approved'
                                                  : 'Rejected',
                                              style: TextStyle(
                                                color:
                                                    selectedBoard!.isApproved ??
                                                            false
                                                        ? Colors.green
                                                        : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        PopupMenuButton<int>(
                                          icon: Icon(Icons.settings),
                                          itemBuilder: (context) => [
                                            PopupMenuItem<int>(
                                              value: 1,
                                              child: ListTile(
                                                leading: Icon(Icons.settings),
                                                // Change to gear icon
                                                title: Text('Settings'),
                                                onTap: () {
                                                  // Handle Settings
                                                },
                                              ),
                                            ),
                                            PopupMenuItem<int>(
                                              value: 2,
                                              child: ListTile(
                                                leading: Icon(Icons.schedule),
                                                title: Text('Schedule'),
                                                onTap: () async {
                                                  final selectedData =
                                                      await Navigator.push<
                                                          DateTimeSlot>(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ScheduleScreen(
                                                        onConfirm:
                                                            (selectedData) async {
                                                          Navigator.pop(context,
                                                              selectedData);
                                                        },
                                                        context: context,
                                                      ),
                                                    ),
                                                  );
                                                  // Handle selectedData
                                                  if (selectedData != null) {
                                                    context
                                                        .read<BoardCubit>()
                                                        .updateBoard(
                                                          selectedBoard!,
                                                          selectedData,
                                                          context,
                                                        );
                                                  }
                                                },
                                              ),
                                            ),
                                            PopupMenuItem<int>(
                                              value: 3,
                                              child: ListTile(
                                                leading: Icon(Icons.delete),
                                                title: Text('Delete'),
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Confirm Deletion'),
                                                        content: Text(
                                                            'Are you sure you want to delete this board?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child:
                                                                Text('Cancel'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child:
                                                                Text('Delete'),
                                                            onPressed: () {
                                                              context
                                                                  .read<
                                                                      BoardCubit>()
                                                                  .deleteBoard(
                                                                      selectedBoard!);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
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
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Center(
                              child: Text('Select an item from the list'),
                            ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
