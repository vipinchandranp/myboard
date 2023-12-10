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
    if (state is BoardLoaded) {
      final currentBoards = List<Board>.from((state as BoardLoaded).boards);
      final index = currentBoards.indexOf(board);
      if (index != -1) {
        final displayDetails = currentBoards[index].displayDetails;
        if(displayDetails != null){
          displayDetails.add(dateTimeSlot); // Add the dateTimeSlot to displayDetails
        }
        boardRepository.updateBoard(currentBoards[index]);
        final boards = await boardRepository.getBoardItems();
        emit(BoardLoaded(boards: boards));
      }
    }
  }



  void setAvailableDisplays(List<String> displays) {
    // Update the state with the available displays
    emit(BoardDisplaysLoaded(displays));
  }
}
