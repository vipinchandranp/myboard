import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/models/board_with_image.dart';
import 'package:myboard/repositories/board_repository.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepository boardRepository;

  BoardCubit(this.boardRepository) : super(BoardInitial());

  List<BoardWithImage> get boardsWithImages {
    if (state is BoardLoaded) {
      return (state as BoardLoaded).boardsWithImages;
    } else {
      return [];
    }
  }

  void createBoard(Board newBoard, BuildContext context) async {
    try {
      await boardRepository.saveBoardItem(context, newBoard);
      emit(BoardSaved());
    } catch (e) {
      emit(BoardError(message: 'Failed to fetch board items.'));
    }
  }

  void fetchBoardItems({int pageSize = 10, bool initialLoad = true}) async {
    emit(BoardLoading());
    if (initialLoad) {
      // Fetch only the initial 10 items
      final boards = await boardRepository.getBoardItems(page: 1, size: 10);
      emit(BoardLoaded(boardsWithImages: boards));
    } else {
      // Fetch more items based on the current state
      if (state is BoardLoaded) {
        final currentBoards =
            List<BoardWithImage>.from((state as BoardLoaded).boardsWithImages);
        final currentPage = currentBoards.length ~/ pageSize + 1;
        try {
          final additionalBoardWithImages = await boardRepository
              .getPaginatedBoardItems(currentPage, pageSize);

          currentBoards.addAll(additionalBoardWithImages);
          emit(BoardLoaded(boardsWithImages: List.from(currentBoards)));
        } catch (e) {
          emit(BoardError(message: 'Failed to fetch additional board items.'));
        }
      }
    }
  }

  Future<void> fetchPaginatedBoardItems(int page, int pageSize) async {
    emit(BoardLoading());

    try {
      final boardsWithImages =
          await boardRepository.getPaginatedBoardItems(page, pageSize);
      emit(BoardWithImagesLoaded(boardsWithImages: boardsWithImages));
    } catch (e) {
      emit(BoardError(message: 'Failed to fetch paginated board items.'));
    }
  }

  void updateBoard(
      Board board, DateTimeSlot dateTimeSlot, BuildContext context) async {
    // Implement your update logic here
  }

  void setAvailableDisplays(List<String> displays) {
    emit(BoardDisplaysLoaded(displays));
  }

  void fetchTitleAndIdData() async {
    emit(BoardItemsTitleLoading());

    try {
      final titleIdData = await boardRepository.getTitleAndId();
      emit(BoardItemsTitleLoaded(boardItemsTitle: titleIdData));
    } catch (e) {
      emit(BoardError(message: 'Failed to fetch title and ID data.'));
    }
  }

  void getBoardImageById(String boardId) async {
    try {
      final dynamic boardDetails =
          await boardRepository.getBoardImageById(boardId);

      if (boardDetails is Uint8List) {
        emit(BoardImageLoaded(imageBytes: boardDetails));
      } else {
        print('It\'s not Uint8List');
      }
    } catch (e) {
      emit(BoardError(message: 'Failed to fetch board details.'));
    }
  }
}
