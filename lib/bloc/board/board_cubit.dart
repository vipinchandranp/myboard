import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/repositories/board_repository.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/utils/user_utils.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepository boardRepository;

  BoardCubit(this.boardRepository) : super(BoardInitial());

  List<Board> get boards {
    if (state is BoardLoaded) {
      return (state as BoardLoaded).boards;
    } else {
      return []; // or throw an exception, depending on your use case
    }
  }

  void createBoard(Board newBoard, BuildContext context) async {
    await boardRepository.saveBoardItem(context, newBoard); // Save the board to the repository

    try {
      final boards =
      await boardRepository.getBoardItems(); // Fetch all boards from the repository
      emit(BoardLoaded(boards: boards));
    } catch (e) {
      emit(BoardError(message: 'Failed to fetch board items.'));
    }
  }

  Future<void> fetchBoardItems() async {
    emit(BoardLoading());

    try {
      final boards = await boardRepository.getBoardItems();
      emit(BoardLoaded(boards: boards));
    } catch (e) {
      emit(BoardError(message: 'Failed to fetch board items.'));
    }
  }

  void deleteBoard(Board board) {
    if (state is BoardLoaded) {
      final currentBoards = List<Board>.from((state as BoardLoaded).boards);
      currentBoards.remove(board);
      emit(BoardLoaded(boards: currentBoards));
    }
  }


  void updateBoard(Board board, DateTimeSlot dateTimeSlot, BuildContext context) async {

  }






  void setAvailableDisplays(List<String> displays) {
    // Update the state with the available displays
    emit(BoardDisplaysLoaded(displays));
  }
}
