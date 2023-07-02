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

  void createBoard(Board newBoard, BuildContext context) async {
    await boardRepository.saveBoardItem(newBoard); // Save the board to the repository

    try {
      final boards =
      await boardRepository.getBoardItems(UserUtils.getLoggedInUser(context)); // Fetch all boards from the repository
      emit(BoardLoaded(boards: boards));
    } catch (e) {
      emit(BoardError(message: 'Failed to fetch board items.'));
    }
  }

  Future<void> fetchBoardItems(MyBoardUser? user) async {
    emit(BoardLoading());

    try {
      final boards = await boardRepository.getBoardItems(user);
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
    if (state is BoardLoaded) {
      final currentBoards = List<Board>.from((state as BoardLoaded).boards);
      final index = currentBoards.indexOf(board);
      if (index != -1) {
        currentBoards[index].displayDetails.add(dateTimeSlot);
        boardRepository.updateBoard(currentBoards[index]);
        final boards = await boardRepository.getBoardItems(UserUtils.getLoggedInUser(context));
        emit(BoardLoaded(boards: boards));
      }
    }
  }



  void setAvailableDisplays(List<String> displays) {
    // Update the state with the available displays
    emit(BoardDisplaysLoaded(displays));
  }
}
