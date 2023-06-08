
import 'package:flutter/material.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/screens/create_board_screen.dart';

class BoardScreen extends StatelessWidget {
  final List<Board> boardItems;

  BoardScreen({required this.boardItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Board Items'),
      ),
      body: ListView.builder(
        itemCount: boardItems.length,
        itemBuilder: (context, index) {
          final boardItem = boardItems[index];
          return ListTile(
            title: Text(boardItem.title),
          );
        },
      ),
    );
  }
}