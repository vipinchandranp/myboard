import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/models/board.dart';
import 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit() : super(BoardInitial());

  void createBoard(String title, String description) {
    final newBoard = Board(title: title, description: description);

    if (state is BoardLoaded) {
      final List<Board> currentBoards = (state as BoardLoaded).boards;
      currentBoards.add(newBoard);
      emit(BoardLoaded(currentBoards));
    } else {
      emit(BoardLoaded([newBoard]));
    }
  }
}
