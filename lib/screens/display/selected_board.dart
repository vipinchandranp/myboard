import 'package:flutter/material.dart';
import '../../models/board/board.dart'; // Ensure this import is correct
import '../board/board_card.dart';

class SelectedBoardWidget extends StatelessWidget {
  final Board? selectedBoard; // This is the named parameter

  const SelectedBoardWidget({Key? key, this.selectedBoard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedBoard != null) ...[
            Text(
              'Selected Board: ${selectedBoard!.boardName}', // Accessing boardName
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            BoardCardWidget(
              board: selectedBoard!, // Pass the entire Board object
              isSelected: true, // Set this based on your requirements
            ),
          ] else ...[
            const Text(
              'No board selected.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
