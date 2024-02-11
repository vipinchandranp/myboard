import 'dart:typed_data';

import 'package:myboard/models/board.dart';

class BoardWithImage {
  final Board board;
  final Uint8List imageBytes;

  BoardWithImage({
    required this.board,
    required this.imageBytes,
  });
}
