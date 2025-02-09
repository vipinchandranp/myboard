import 'package:flutter/material.dart';
import 'package:myboard/repository/board_repository.dart';
import 'package:myboard/repository/display_repository.dart'; // Ensure the correct import for your service
import '../../utils/content_type.dart'; // Make sure this import is correct

class LikeWidget extends StatefulWidget {
  final String contentId; // The content ID (display or board)
  final MBContentType contentType; // The type of content (DISPLAY or BOARD)

  LikeWidget({
    required this.contentId,
    required this.contentType,
  });

  @override
  _LikeWidgetState createState() => _LikeWidgetState();
}

class _LikeWidgetState extends State<LikeWidget> {
  bool _isLiked = false;

  // Toggle like functionality
  Future<void> _toggleLike() async {
    try {
      if (widget.contentType == MBContentType.DISPLAY) {
        if (_isLiked) {
          // Undo like for display
          final success = await DisplayService(context).undoLikeDisplay(widget.contentId);
          if (success != null) {
            setState(() {
              _isLiked = false;
            });
            print("Like undone for display ${widget.contentId}.");
          } else {
            print("Failed to undo like for display ${widget.contentId}.");
          }
        } else {
          // Like display
          final success = await DisplayService(context).likeDisplay(widget.contentId);
          if (success != null) {
            setState(() {
              _isLiked = true;
            });
            print("Display ${widget.contentId} has been liked.");
          } else {
            print("Failed to like display ${widget.contentId}.");
          }
        }
      } else if (widget.contentType == MBContentType.BOARD) {
        // Add logic for board like or undo like if needed
        print("Board functionality not yet implemented.");
      }
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Like this content:", style: TextStyle(fontSize: 16)),
        IconButton(
          icon: Icon(
            _isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
            color: _isLiked ? Colors.blue : Colors.grey,
          ),
          onPressed: _toggleLike, // Toggle like on press
        ),
      ],
    );
  }
}
