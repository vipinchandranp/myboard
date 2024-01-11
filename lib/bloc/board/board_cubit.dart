import 'dart:typed_data';

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
    await boardRepository.saveBoardItem(context, newBoard);

    try {
      final boards = await boardRepository.getBoardItems();
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

  void updateBoard(
      Board board, DateTimeSlot dateTimeSlot, BuildContext context) async {}

  void setAvailableDisplays(List<String> displays) {
    // Update the state with the available displays
    emit(BoardDisplaysLoaded(displays));
  }

  void fetchTitleAndIdData() async {
    emit(
        BoardItemsTitleLoading()); // You might want to create a loading state if needed

    try {
      final titleIdData = await boardRepository.getTitleAndId();
      emit(BoardItemsTitleLoaded(boardItemsTitle: titleIdData));
    } catch (e) {
      emit(BoardError(message: 'Failed to fetch title and ID data.'));
    }
  }

  void getBoardImageById(String boardId) async {
    try {
      final dynamic boardDetails = await boardRepository.getBoardImageById(boardId);

      if (boardDetails is Uint8List) {
        // Handle the case where boardDetails is image bytes
        emit(BoardImageLoaded(imageBytes: boardDetails));
      } else {
        print('It\'s not Uint8List');
      }
    } catch (e) {
      emit(BoardError(message: 'Failed to fetch board details.'));
    }
  }



}
