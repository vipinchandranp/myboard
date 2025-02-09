import 'package:flutter/material.dart';
import 'package:myboard/repository/board_repository.dart';  // Ensure this import is correct
import 'package:myboard/repository/display_repository.dart'; // Ensure this import is correct
import '../../utils/content_type.dart'; // Make sure this import is correct

class LikeDislikeWidget extends StatefulWidget {
  final String contentId; // The content ID (display or board)
  final MBContentType contentType; // The type of content (DISPLAY or BOARD)

  LikeDislikeWidget({
    required this.contentId,
    required this.contentType,
  });

  @override
  _LikeDislikeWidgetState createState() => _LikeDislikeWidgetState();
}

class _LikeDislikeWidgetState extends State<LikeDislikeWidget> {
  bool _isLiked = false;
  bool _isDisliked = false;

  // Toggle like functionality
  Future<void> _toggleLike() async {
    if (_isLiked) {
      // Undo like
      await _undoLike();
    } else {
      // Like content and undo dislike if needed
      try {
        if (widget.contentType == MBContentType.DISPLAY) {
          final success = await DisplayService(context).likeDisplay(widget.contentId);
          if (success != null) {
            setState(() {
              _isLiked = true;
              _isDisliked = false;
            });
            print("Display ${widget.contentId} has been liked.");
          } else {
            print("Failed to like display ${widget.contentId}.");
          }
        } else if (widget.contentType == MBContentType.BOARD) {
          final success = await BoardService(context).likeBoard(widget.contentId);
          if (success) {
            setState(() {
              _isLiked = true;
              _isDisliked = false;
            });
            print("Board ${widget.contentId} has been liked.");
          } else {
            print("Failed to like board ${widget.contentId}.");
          }
        }
      } catch (e) {
        print('Error liking content: $e');
      }
    }
  }

  // Toggle dislike functionality
  Future<void> _toggleDislike() async {
    if (_isDisliked) {
      // Undo dislike
      await _undoDislike();
    } else {
      // Dislike content and undo like if needed
      try {
        if (widget.contentType == MBContentType.DISPLAY) {
          final success = await DisplayService(context).dislikeDisplay(widget.contentId);
          if (success != null) {
            setState(() {
              _isDisliked = true;
              _isLiked = false;
            });
            print("Display ${widget.contentId} has been disliked.");
          } else {
            print("Failed to dislike display ${widget.contentId}.");
          }
        } else if (widget.contentType == MBContentType.BOARD) {
          final success = await BoardService(context).dislikeBoard(widget.contentId);
          if (success) {
            setState(() {
              _isDisliked = true;
              _isLiked = false;
            });
            print("Board ${widget.contentId} has been disliked.");
          } else {
            print("Failed to dislike board ${widget.contentId}.");
          }
        }
      } catch (e) {
        print('Error disliking content: $e');
      }
    }
  }

  // Undo like
  Future<void> _undoLike() async {
    try {
      if (widget.contentType == MBContentType.DISPLAY) {
        final success = await DisplayService(context).undoLikeDisplay(widget.contentId);
        if (success != null) {
          setState(() {
            _isLiked = false;
          });
          print("Like undone for display ${widget.contentId}.");
        } else {
          print("Failed to undo like for display ${widget.contentId}.");
        }
      } else if (widget.contentType == MBContentType.BOARD) {
        final success = await BoardService(context).undoLikeBoard(widget.contentId);
        if (success) {
          setState(() {
            _isLiked = false;
          });
          print("Like undone for board ${widget.contentId}.");
        } else {
          print("Failed to undo like for board ${widget.contentId}.");
        }
      }
    } catch (e) {
      print('Error undoing like: $e');
    }
  }

  // Undo dislike
  Future<void> _undoDislike() async {
    try {
      if (widget.contentType == MBContentType.DISPLAY) {
        final success = await DisplayService(context).undoDislikeDisplay(widget.contentId);
        if (success != null) {
          setState(() {
            _isDisliked = false;
          });
          print("Dislike undone for display ${widget.contentId}.");
        } else {
          print("Failed to undo dislike for display ${widget.contentId}.");
        }
      } else if (widget.contentType == MBContentType.BOARD) {
        final success = await BoardService(context).undoDislikeBoard(widget.contentId);
        if (success) {
          setState(() {
            _isDisliked = false;
          });
          print("Dislike undone for board ${widget.contentId}.");
        } else {
          print("Failed to undo dislike for board ${widget.contentId}.");
        }
      }
    } catch (e) {
      print('Error undoing dislike: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            _isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
            color: _isLiked ? Colors.blue : Colors.grey,
          ),
          onPressed: _toggleLike, // Toggle like on press
        ),
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
