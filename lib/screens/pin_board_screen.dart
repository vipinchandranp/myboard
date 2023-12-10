import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    // Dispatch the event to fetch board items when the screen loads
    context.read<BoardCubit>().fetchBoardItems();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoardCubit, BoardState>(
      listener: (context, state) {
        // Handle state changes if needed
      },
      builder: (context, state) {
        if (state is BoardLoaded) {
          final List<Board> boards = state.boards;

          return Container(
            child: Scaffold(
              body: Container(
                child: Column(
                  children: [
                    Padding(padding: const EdgeInsets.all(8.0)),
                    Expanded(
                      child: ListView.builder(
                        itemCount: boards.length,
                        itemBuilder: (context, index) {
                          final Board board = boards[index];
                          if (_searchController.text.isEmpty ||
                              board.title!.toLowerCase().contains(
                                  _searchController.text.toLowerCase())) {
                            return Container(
                              child: Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: ListTile(
                                  title: Text(board.title ?? ''),
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          // Shadow color
                                          spreadRadius: 2,
                                          // Spread radius of the shadow
                                          blurRadius: 5,
                                          // Blur radius of the shadow
                                          offset: Offset(
                                              0, 2), // Offset of the shadow
                                        ),
                                      ],
                                      shape: BoxShape
                                          .circle, // Shape of the container (can be adjusted as needed)
                                    ),
                                    child: Icon(
                                      Icons.play_circle_filled_sharp,
                                      color: Colors.red,
                                      size: 30, // Size of the icon
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(board.description ?? ''),
                                      if (board.displayDetails != null)
                                        for (var entry in board.displayDetails!)
                                          Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 20, 20, 20),
                                                    child: Text(
                                                        'Username: ${entry.username}',
                                                        style: TextStyle(
                                                            fontSize: 22))),
                                                Divider(),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 20, 20, 20),
                                                    child: Text(
                                                        'Display: ${entry.display}',
                                                        style: TextStyle(
                                                            fontSize: 22))),
                                                Divider(),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 20, 20, 20),
                                                    child: Text(
                                                        'Date: ${entry.date.toLocal()}',
                                                        style: TextStyle(
                                                            fontSize: 22))),
                                                Divider(),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 20, 20, 20),
                                                    child: Text(
                                                        'Start Time: ${entry.startTime.format(context)}',
                                                        style: TextStyle(
                                                            fontSize: 22))),
                                                Divider(),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 20, 20, 20),
                                                    child: Text(
                                                        'End Time: ${entry.endTime.format(context)}',
                                                        style: TextStyle(
                                                            fontSize: 22))),
                                                Divider(),
                                              ],
                                            ),
                                          ),
                                      Divider(),
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
                                            final selectedData = await Navigator
                                                .push<DateTimeSlot>(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ScheduleScreen(
                                                        onConfirm:
                                                            (selectedData) async {
                                                          Navigator.pop(context,
                                                              selectedData);
                                                        },
                                                        context: context),
                                              ),
                                            );
                                            // Handle selectedData
                                            if (selectedData != null) {
                                              context
                                                  .read<BoardCubit>()
                                                  .updateBoard(board,
                                                      selectedData, context);
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
                                                  title:
                                                      Text('Confirm Deletion'),
                                                  content: Text(
                                                      'Are you sure you want to delete this board?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Delete'),
                                                      onPressed: () {
                                                        context
                                                            .read<BoardCubit>()
                                                            .deleteBoard(board);
                                                        Navigator.of(context)
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
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
