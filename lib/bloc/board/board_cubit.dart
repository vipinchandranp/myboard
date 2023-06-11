import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/bloc/board/board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit() : super(BoardInitial());

  void createBoard(String title, String description) {
    final newBoard = Board(title: title, description: description);

    if (state is BoardLoaded) {
      final currentBoards = List<Board>.from((state as BoardLoaded).boards);
      currentBoards.add(newBoard);
      emit(BoardLoaded(boards: currentBoards));
    } else {
      emit(BoardLoaded(boards: [newBoard]));
    }
  }

  void deleteBoard(Board board) {
    if (state is BoardLoaded) {
      final currentBoards = List<Board>.from((state as BoardLoaded).boards);
      currentBoards.remove(board);
      emit(BoardLoaded(boards: currentBoards));
    }
  }

  void addDateTimeSlots(Board board, Map<String, DateTimeSlot> dateTimeSlots) {
    if (state is BoardLoaded) {
      final currentBoards = List<Board>.from((state as BoardLoaded).boards);
      final index = currentBoards.indexOf(board);
      if (index != -1) {
        final updatedBoard = currentBoards[index].copyWith(
          displayDateTimeMap: dateTimeSlots,
        );
        currentBoards[index] = updatedBoard;
        emit(BoardLoaded(boards: currentBoards));
      }
    }
  }

  void updateBoardDateTime(
      Board board, String display, DateTimeSlot dateTimeSlot) {
    if (state is BoardLoaded) {
      final currentBoards = List<Board>.from((state as BoardLoaded).boards);
      final index = currentBoards.indexOf(board);
      if (index != -1) {
        final updatedBoard = currentBoards[index].copyWith(
          displayDateTimeMap: {
            ...board.displayDateTimeMap,
            display: dateTimeSlot
          },
        );
        currentBoards[index] = updatedBoard;
        emit(BoardLoaded(boards: currentBoards));
      }
    }
  }

  void updateSelectedDisplays(Board board, List<String> selectedDisplays) {
    if (state is BoardLoaded) {
      final List<Board> updatedBoards = (state as BoardLoaded).boards.map((b) {
        if (b == board) {
          return b.copyWith(selectedDisplays: selectedDisplays);
        }
        return b;
      }).toList();

      emit(BoardLoaded(boards: updatedBoards));
    }
  }

  void updateBoard(Board board, DateTimeSlot selectedData) {
    // Create a new modifiable map based on the existing map
    final Map<String, DateTimeSlot> updatedMap = Map.from(board.displayDateTimeMap);

    // Perform the necessary updates to the map with the selected data
    updatedMap[selectedData.display] = selectedData;

    // Create a new Board object with the updated map
    final updatedBoard = board.copyWith(displayDateTimeMap: updatedMap);

    // Update the board using the BoardCubit
    emit(BoardLoaded(boards: [updatedBoard]));
  }
}
