import 'package:flutter/material.dart';
import 'package:myboard/repository/board_repository.dart';
import 'package:myboard/repository/display_repository.dart'; // Ensure this import is correct
import '../../utils/ItemType.dart'; // Make sure this import is correct

class DislikeWidget extends StatefulWidget {
  final String contentId; // The content ID (display or board)
  final ItemType contentType; // The type of content (DISPLAY or BOARD)

  DislikeWidget({
    required this.contentId,
    required this.contentType,
  });

  @override
  _DislikeWidgetState createState() => _DislikeWidgetState();
}

class _DislikeWidgetState extends State<DislikeWidget> {
  bool _isDisliked = false;
  int _dislikesCount = 0; // Holds the number of dislikes

  @override
  void initState() {
    super.initState();
    _loadDislikesCount();
  }

  // Load the current number of dislikes for the content
  Future<void> _loadDislikesCount() async {
    try {
      if (widget.contentType == ItemType.DISPLAY) {
        final count = await DisplayService(context).getNumberOfDisLikes(widget.contentId);
        setState(() {
          _dislikesCount = count ?? 0;
        });
      } else if (widget.contentType == ItemType.BOARD) {
        final count = await BoardService(context).getNumberOfDisLikes(widget.contentId);
        setState(() {
          _dislikesCount = count ?? 0;
        });
      }
    } catch (e) {
      print("Error loading dislikes count: $e");
    }
  }

  // Toggle dislike status and update the dislikes count
  Future<void> _toggleDislike() async {
    try {
      if (widget.contentType == ItemType.DISPLAY) {
        if (_isDisliked) {
          final success = await DisplayService(context).undoDislikeDisplay(widget.contentId);
          if (success) {
            setState(() {
              _isDisliked = false;
              _dislikesCount = (_dislikesCount > 0) ? _dislikesCount - 1 : 0;
            });
            print("Dislike undone for display ${widget.contentId}.");
          } else {
            print("Failed to undo dislike for display ${widget.contentId}.");
          }
        } else {
          final success = await DisplayService(context).dislikeDisplay(widget.contentId);
          if (success) {
            setState(() {
              _isDisliked = true;
              _dislikesCount++;
            });
            print("Display ${widget.contentId} has been disliked.");
          } else {
            print("Failed to dislike display ${widget.contentId}.");
          }
        }
      } else if (widget.contentType == ItemType.BOARD) {
        // Add board logic if needed
        print("Board functionality not yet implemented.");
      }
    } catch (e) {
      print("Error toggling dislike: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Stack used to overlay the badge on the dislike icon
        Stack(
          children: [
            IconButton(
              icon: Icon(
                _isDisliked ? Icons.thumb_down : Icons.thumb_down_off_alt,
                color: _isDisliked ? Colors.red : Colors.grey,
              ),
              onPressed: _toggleDislike,
            ),
            Positioned(
              right: 0,
              top: 0,
              child: _dislikesCount > 0
                  ? Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$_dislikesCount',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              )
                  : SizedBox.shrink(),
            ),
          ],
        ),
        SizedBox(width: 8),
        Text("Dislike")
      ],
    );
  }
}
