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
  int _likesCount = 0; // Holds the number of likes

  @override
  void initState() {
    super.initState();
    _loadLikesCount();
  }

  // Load the current number of likes for the content
  Future<void> _loadLikesCount() async {
    try {
      if (widget.contentType == MBContentType.DISPLAY) {
        final count = await DisplayService(context).getNumberOfLikes(widget.contentId);
        setState(() {
          _likesCount = count ?? 0;
        });
      } else if (widget.contentType == MBContentType.BOARD) {
        final count = await BoardService(context).getNumberOfLikes(widget.contentId);
        setState(() {
          _likesCount = count ?? 0;
        });
      }
    } catch (e) {
      print("Error loading likes count: $e");
    }
  }

  // Toggle like status and update the likes count
  Future<void> _toggleLike() async {
    try {
      if (widget.contentType == MBContentType.DISPLAY) {
        if (_isLiked) {
          final success = await DisplayService(context).undoLikeDisplay(widget.contentId);
          if (success) {
            setState(() {
              _isLiked = false;
              _likesCount = (_likesCount > 0) ? _likesCount - 1 : 0;
            });
            print("Like undone for display ${widget.contentId}.");
          } else {
            print("Failed to undo like for display ${widget.contentId}.");
          }
        } else {
          final success = await DisplayService(context).likeDisplay(widget.contentId);
          if (success) {
            setState(() {
              _isLiked = true;
              _likesCount++;
            });
            print("Display ${widget.contentId} has been liked.");
          } else {
            print("Failed to like display ${widget.contentId}.");
          }
        }
      } else if (widget.contentType == MBContentType.BOARD) {
        // Add board logic if needed
        print("Board functionality not yet implemented.");
      }
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Stack used to overlay the badge on the like icon
        Stack(
          children: [
            IconButton(
              icon: Icon(
                _isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                color: _isLiked ? Colors.blue : Colors.grey,
              ),
              onPressed: _toggleLike,
            ),
            Positioned(
              right: 0,
              top: 0,
              child: _likesCount > 0
                  ? Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$_likesCount',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              )
                  : SizedBox.shrink(),
            ),
          ],
        ),
        SizedBox(width: 8),
        Text("Like")
      ],
    );
  }
}
