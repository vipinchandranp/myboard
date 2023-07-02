import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/screens/schedule_screen.dart';
import 'package:myboard/utils/user_utils.dart';

class PinBoardScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoardCubit, BoardState>(
      listener: (context, state) {
        // Handle state changes if needed
      },
      builder: (context, state) {
        if (state is BoardLoaded) {
          final List<Board> boards = state.boards;

          return Scaffold(
            appBar: AppBar(
              title: Text('My Board Items'),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    // Call the method to fetch board items here
                    context.read<BoardCubit>().fetchBoardItems(UserUtils.getLoggedInUser(context));
                  },
                ),
              ],
            ),
            body: Column(
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
                      final Board board = boards[index];
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
                                if (board.displayDetails.isNotEmpty)
                                  for (var entry in board.displayDetails)
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Username: ${entry.username}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Display: ${entry.display}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Date: ${entry.date.toLocal()}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Start Time: ${entry.startTime.format(context)}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'End Time: ${entry.endTime.format(context)}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
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
                                  value: 3,
                                  child: ListTile(
                                    leading: Icon(Icons.schedule),
                                    title: Text('Schedule'),
                                    onTap: () async {
                                      final selectedData =
                                      await Navigator.push<DateTimeSlot>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ScheduleScreen(
                                              onConfirm: (selectedData) async {
                                                Navigator.pop(context, selectedData);
                                              }),
                                        ),
                                      );
                                      // Handle selectedData
                                      if (selectedData != null) {
                                        context
                                            .read<BoardCubit>()
                                            .updateBoard(board, selectedData, context);
                                      }
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
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
