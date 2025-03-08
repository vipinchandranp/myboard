import 'package:flutter/material.dart';
import 'package:myboard/repository/board_repository.dart'; // Ensure this import is correct
import 'package:myboard/repository/display_repository.dart'; // Ensure this import is correct
import '../../utils/ItemType.dart';

class LikeDislikeWidget extends StatefulWidget {
  final String contentId; // The content ID (display or board)
  final ItemType contentType; // The type of content (DISPLAY or BOARD)

  // New properties: initial counts and reaction status passed in from parent
  final int initialLikes;
  final int initialDislikes;
  final bool initiallyLiked;
  final bool initiallyDisliked;

  LikeDislikeWidget({
    required this.contentId,
    required this.contentType,
    required this.initialLikes,
    required this.initialDislikes,
    required this.initiallyLiked,
    required this.initiallyDisliked,
  });

  @override
  _LikeDislikeWidgetState createState() => _LikeDislikeWidgetState();
}

class _LikeDislikeWidgetState extends State<LikeDislikeWidget> {
  bool _isLiked = false;
  bool _isDisliked = false;
  int _likesCount = 0;
  int _dislikesCount = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the state from the widget's initial values
    _likesCount = widget.initialLikes;
    _dislikesCount = widget.initialDislikes;
    _isLiked = widget.initiallyLiked;
    _isDisliked = widget.initiallyDisliked;
  }

  // Toggle like functionality
  Future<void> _toggleLike() async {
    if (_isLiked) {
      await _undoLike();
    } else {
      await _performLike();
    }
  }

  Future<void> _performLike() async {
    try {
      bool? success;
      if (widget.contentType == ItemType.DISPLAY) {
        success = await DisplayService(context).likeDisplay(widget.contentId);
      } else if (widget.contentType == ItemType.BOARD) {
        success = await BoardService(context).likeBoard(widget.contentId);
      }
      if (success == true) {
        setState(() {
          // If switching from dislike to like, update counts accordingly.
          if (_isDisliked) {
            _dislikesCount = (_dislikesCount > 0) ? _dislikesCount - 1 : 0;
            _isDisliked = false;
          }
          _isLiked = true;
          _likesCount++;
        });
        print("${widget.contentType} ${widget.contentId} has been liked.");
      } else {
        print("Failed to like ${widget.contentType} ${widget.contentId}.");
      }
    } catch (e) {
      print('Error liking content: $e');
    }
  }

  // Toggle dislike functionality
  Future<void> _toggleDislike() async {
    if (_isDisliked) {
      await _undoDislike();
    } else {
      await _performDislike();
    }
  }

  Future<void> _performDislike() async {
    try {
      bool? success;
      if (widget.contentType == ItemType.DISPLAY) {
        success = await DisplayService(context).dislikeDisplay(widget.contentId);
      } else if (widget.contentType == ItemType.BOARD) {
        success = await BoardService(context).dislikeBoard(widget.contentId);
      }
      if (success == true) {
        setState(() {
          // If switching from like to dislike, update counts accordingly.
          if (_isLiked) {
            _likesCount = (_likesCount > 0) ? _likesCount - 1 : 0;
            _isLiked = false;
          }
          _isDisliked = true;
          _dislikesCount++;
        });
        print("${widget.contentType} ${widget.contentId} has been disliked.");
      } else {
        print("Failed to dislike ${widget.contentType} ${widget.contentId}.");
      }
    } catch (e) {
      print('Error disliking content: $e');
    }
  }

  // Undo like
  Future<void> _undoLike() async {
    try {
      bool? success;
      if (widget.contentType == ItemType.DISPLAY) {
        success = await DisplayService(context).undoLikeDisplay(widget.contentId);
      } else if (widget.contentType == ItemType.BOARD) {
        success = await BoardService(context).undoLikeBoard(widget.contentId);
      }
      if (success == true) {
        setState(() {
          _isLiked = false;
          _likesCount = (_likesCount > 0) ? _likesCount - 1 : 0;
        });
        print("Like undone for ${widget.contentType} ${widget.contentId}.");
      } else {
        print("Failed to undo like for ${widget.contentType} ${widget.contentId}.");
      }
    } catch (e) {
      print('Error undoing like: $e');
    }
  }

  // Undo dislike
  Future<void> _undoDislike() async {
    try {
      bool? success;
      if (widget.contentType == ItemType.DISPLAY) {
        success = await DisplayService(context).undoDislikeDisplay(widget.contentId);
      } else if (widget.contentType == ItemType.BOARD) {
        success = await BoardService(context).undoDislikeBoard(widget.contentId);
      }
      if (success == true) {
        setState(() {
          _isDisliked = false;
          _dislikesCount = (_dislikesCount > 0) ? _dislikesCount - 1 : 0;
        });
        print("Dislike undone for ${widget.contentType} ${widget.contentId}.");
      } else {
        print("Failed to undo dislike for ${widget.contentType} ${widget.contentId}.");
      }
    } catch (e) {
      print('Error undoing dislike: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Like button with count using thumpsup.png
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              iconSize: 24, // Adjusted icon size
              icon: Image.asset(
                'assets/thumpsup.png',
                width: 24,
                height: 24,
                color: _isLiked ? null : Colors.grey, // Tint grey if not liked
              ),
              onPressed: _toggleLike,
            ),
            Text('$_likesCount'),
          ],
        ),
        const SizedBox(width: 20),
        // Dislike button with count using thumpsdown.png
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              iconSize: 24, // Adjusted icon size
              icon: Image.asset(
                'assets/thumpsdown.png',
                width: 24,
                height: 24,
                color: _isDisliked ? null : Colors.grey, // Tint grey if not disliked
              ),
              onPressed: _toggleDislike,
            ),
            Text('$_dislikesCount'),
          ],
        ),
      ],
    );
  }
}
