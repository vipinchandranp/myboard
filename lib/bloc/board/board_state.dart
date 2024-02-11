import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:myboard/models/board-id-title.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/models/board_with_image.dart';

class BoardState extends Equatable {
  const BoardState();

  @override
  List<Object> get props => [];
}

class BoardInitial extends BoardState {}

class BoardLoading extends BoardState {}

class BoardSaved extends BoardState {
  const BoardSaved();

  @override
  List<Object> get props => [];
}

class BoardLoaded extends BoardState {
  final List<BoardWithImage> boardsWithImages;

  const BoardLoaded({required this.boardsWithImages});

  @override
  List<Object> get props => [boardsWithImages];
}

class BoardError extends BoardState {
  final String message;

  const BoardError({required this.message});

  @override
  List<Object> get props => [message];
}

class BoardDisplaysLoaded extends BoardState {
  final List<String> displays;

  const BoardDisplaysLoaded(this.displays);

  @override
  List<Object> get props => [displays];
}

class BoardItemsTitleLoaded extends BoardState {
  final List<BoardIdTitle> boardItemsTitle;

  const BoardItemsTitleLoaded({required this.boardItemsTitle});

  @override
  List<Object> get props => [boardItemsTitle];
}

class BoardImageLoaded extends BoardState {
  final Uint8List? imageBytes;

  const BoardImageLoaded({required this.imageBytes});

  @override
  List<Object> get props => [imageBytes ?? []];
}

class BoardItemsTitleLoading extends BoardState {}

class BoardWithImagesLoaded extends BoardLoaded {
  BoardWithImagesLoaded({required List<BoardWithImage> boardsWithImages})
      : super(boardsWithImages: boardsWithImages);

// You don't need the static method _convertToRegularBoards here
// The constructor directly initializes the super class with boardsWithImages
}
