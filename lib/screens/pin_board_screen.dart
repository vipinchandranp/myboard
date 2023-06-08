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
              return ListTile(
                title: Text(boards[index].title),
                subtitle: Text(boards[index].description),
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
