import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/board/board_state.dart';

class PinBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardCubit, BoardState>(
      builder: (context, state) {
        if (state is BoardLoaded) {
          final boards = state.boards;

          return ListView.builder(
            itemCount: boards.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.yellow.shade100,
                child: ListTile(
                  title: Text(boards[index].title),
                  subtitle: Text(boards[index].description),
                  trailing: Wrap(
                    spacing: -10.0, // overlap
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.view_agenda),
                        onPressed: () {
                          // View operation
                        },
                        tooltip: 'View', // Tooltip here
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          // Date and Time operation
                        },
                        tooltip: 'Select Date and Time', // Tooltip here
                      ),
                      IconButton(
                        icon: Icon(Icons.location_on),
                        onPressed: () {
                          // Location operation
                        },
                        tooltip: 'Select Location', // Tooltip here
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
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
                                      // Delete operation
                                      context
                                          .read<BoardCubit>()
                                          .deleteBoard(boards[index]);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        tooltip: 'Delete', // Tooltip here
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
