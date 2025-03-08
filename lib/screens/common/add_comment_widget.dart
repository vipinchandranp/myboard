import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myboard/repository/board_repository.dart';
import 'package:myboard/repository/display_repository.dart';
import '../../utils/ItemType.dart';

class AddComment extends StatefulWidget {
  final String contentId;  // The content ID (display or board)
  final ItemType contentType;  // The type of content (DISPLAY or BOARD)

  AddComment({
    required this.contentId,
    required this.contentType,
  });

  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  final TextEditingController _commentController = TextEditingController();

  // Adds a comment to a board
  Future<String?> addCommentToBoard(String boardId, String commentText) async {
    try {
      final response = await BoardService(context).addComment(boardId, commentText);
    } catch (e) {
      print('Error adding comment: $e');
      return null;
    }
    return null;
  }

  // Adds a comment to a specific display
  Future<String?> addCommentToDisplay(String displayId, String commentText) async {
    try {
      final response = await DisplayService(context).addComment(displayId, commentText);
    } catch (e) {
      print('Error adding comment: $e');
      return null;
    }
    return null;
  }

  void _submitComment() async {
    String commentText = _commentController.text;

    if (commentText.isEmpty) {
      return;  // Prevent submission of empty comments
    }

    String? result;

    // Logic to submit the comment based on content type
    if (widget.contentType == ItemType.DISPLAY) {
      result = await addCommentToDisplay(widget.contentId, commentText);
    } else if (widget.contentType == ItemType.BOARD) {
      result = await addCommentToBoard(widget.contentId, commentText);  // Using the updated addComment method
    }

    if (result != null) {
      // You can show a success message or handle it further
      print(result);
    } else {
      // Handle failure if necessary
      print('Failed to add comment');
    }

    _commentController.clear(); // Clear the input field after submission
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0), // Adding top padding here
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add a comment:", style: TextStyle(fontSize: 16)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Write your comment here...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                  maxLines: 4,
                ),
              ),
              IconButton(
                onPressed: _submitComment,
                icon: Icon(Icons.send, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
