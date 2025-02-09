import 'package:flutter/material.dart';
import 'package:myboard/repository/board_repository.dart';
import 'package:myboard/repository/display_repository.dart'; // Ensure this import is correct
import '../../utils/content_type.dart'; // Make sure this import is correct

class DislikeWidget extends StatefulWidget {
  final String contentId; // The content ID (display or board)
  final MBContentType contentType; // The type of content (DISPLAY or BOARD)

  DislikeWidget({
    required this.contentId,
    required this.contentType,
  });

  @override
  _DislikeWidgetState createState() => _DislikeWidgetState();
}

class _DislikeWidgetState extends State<DislikeWidget> {
  bool _isDisliked = false;

  // Toggle dislike functionality
  Future<void> _toggleDislike() async {
    try {
      if (widget.contentType == MBContentType.DISPLAY) {
        if (_isDisliked) {
          // Undo dislike for display
          final success = await DisplayService(context).undoDislikeDisplay(widget.contentId);
          if (success != null) {
            setState(() {
              _isDisliked = false;
            });
            print("Dislike undone for display ${widget.contentId}.");
          } else {
            print("Failed to undo dislike for display ${widget.contentId}.");
          }
        } else {
          // Dislike display
          final success = await DisplayService(context).dislikeDisplay(widget.contentId);
          if (success != null) {
            setState(() {
              _isDisliked = true;
            });
            print("Display ${widget.contentId} has been disliked.");
          } else {
            print("Failed to dislike display ${widget.contentId}.");
          }
        }
      } else if (widget.contentType == MBContentType.BOARD) {
        // Add logic for board dislike or undo dislike if needed
        print("Board functionality not yet implemented.");
      }
    } catch (e) {
      print('Error toggling dislike: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dislike this content:", style: TextStyle(fontSize: 16)),
        IconButton(
          icon: Icon(
            _isDisliked ? Icons.thumb_down : Icons.thumb_down_off_alt,
            color: _isDisliked ? Colors.red : Colors.grey,
          ),
          onPressed: _toggleDislike, // Toggle dislike on press
        ),
      ],
    );
  }
}
