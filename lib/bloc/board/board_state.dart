import 'package:myboard/models/board.dart';

abstract class BoardState {}

class BoardInitial extends BoardState {}

class BoardLoaded extends BoardState {
  final List<Board> boards;

  BoardLoaded({required this.boards});
}