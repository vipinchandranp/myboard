import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myboard/models/board-id-title.dart';

class BoardDetailsScreen extends StatelessWidget {
  final BoardIdTitle board;
  final Uint8List imageBytes;

  BoardDetailsScreen({required this.board, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    print('image content $imageBytes');
    return Scaffold(
      appBar: AppBar(
        title: Text('Board Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Title: ${board.title}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Display other text details here

          // Display image if available
          if (imageBytes != null)
            Expanded(
              child: SingleChildScrollView(
                child: Image.memory(
                  Uint8List.fromList(imageBytes),
                  fit: BoxFit.contain,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
