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

  void deleteBoard(Board board) {
    if (state is BoardLoaded) {
      final List<Board> currentBoards = (state as BoardLoaded).boards;
      currentBoards.remove(board);
      emit(BoardLoaded(currentBoards));
    }
  }

  void addDateTimeSlot(Board board, DateTimeSlot dateTimeSlot) {
    if (state is BoardLoaded) {
      final List<Board> currentBoards = (state as BoardLoaded).boards;
      final index = currentBoards.indexOf(board);
      if (index != -1) {
        final updatedBoard = currentBoards[index].copyWith(
          dateTimeSlot: dateTimeSlot,
        );
        currentBoards[index] = updatedBoard;
        emit(BoardLoaded(currentBoards));
      }
    }
  }

  void updateBoardDateTime(Board board, DateTimeSlot dateTimeSlot) {
    if (state is BoardLoaded) {
      final List<Board> currentBoards = (state as BoardLoaded).boards;
      final index = currentBoards.indexOf(board);
      if (index != -1) {
        final updatedBoard = currentBoards[index].copyWith(
          dateTimeSlot: dateTimeSlot,
        );
        currentBoards[index] = updatedBoard;
        emit(BoardLoaded(currentBoards));
      }
    }
  }
}
