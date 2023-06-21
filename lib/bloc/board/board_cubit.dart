import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/repositories/board_repository.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepository boardRepository;

  BoardCubit(this.boardRepository) : super(BoardInitial());

  void createBoard(Board newBoard) {
    boardRepository.saveBoardItem(newBoard); // Save the board to the repository

    if (state is BoardLoaded) {
      final currentBoards = (state as BoardLoaded).boards;
      currentBoards.add(newBoard);
      emit(BoardLoaded(boards: currentBoards.toList()));
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
            display: dateTimeSlot,
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
    if (state is BoardLoaded) {
      final List<Board> updatedBoards = (state as BoardLoaded).boards.map((b) {
        if (b == board) {
          final updatedMap =
              Map<String, DateTimeSlot>.from(b.displayDateTimeMap);
          updatedMap[selectedData.display] = selectedData;
          return b.copyWith(displayDateTimeMap: updatedMap);
        }
        return b;
      }).toList();

      emit(BoardLoaded(boards: updatedBoards));
    }
  }
}
