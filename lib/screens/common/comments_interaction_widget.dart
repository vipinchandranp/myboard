import 'package:flutter/material.dart';
import 'package:myboard/repository/board_repository.dart';
import 'package:myboard/repository/display_repository.dart';
import '../../models/common/comment.dart';
import '../../utils/ItemType.dart';
import 'AddRatingWidget.dart';
class CommentsInteractionWidget extends StatefulWidget {
  final String contentId; // The content ID (display or board)
  final ItemType contentType; // The type of content (DISPLAY or BOARD)

  const CommentsInteractionWidget({
    Key? key,
    required this.contentId,
    required this.contentType,
  }) : super(key: key);

  @override
  _CommentsInteractionWidgetState createState() =>
      _CommentsInteractionWidgetState();
}

class _CommentsInteractionWidgetState extends State<CommentsInteractionWidget> {
  late Future<List<Comment>?> _commentsFuture;
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _refreshComments();
  }

  void _refreshComments() {
    _commentsFuture = _fetchComments(widget.contentId, widget.contentType);
  }

  Future<List<Comment>?> _fetchComments(
      String contentId, ItemType contentType) async {
    try {
      if (contentType == ItemType.DISPLAY) {
        return await DisplayService(context).getComments(contentId);
      } else if (contentType == ItemType.BOARD) {
        return await BoardService(context).getComments(contentId);
      } else {
        print("Unsupported content type");
        return null;
      }
    } catch (e) {
      print("Error fetching comments: $e");
      return null;
    }
  }

  Future<void> _submitComment(String commentText) async {
    if (commentText.isEmpty) return;

    try {
      if (widget.contentType == ItemType.DISPLAY) {
        await DisplayService(context).addComment(widget.contentId, commentText);
      } else if (widget.contentType == ItemType.BOARD) {
        await BoardService(context).addComment(widget.contentId, commentText);
      }
      _commentController.clear();
      _refreshComments();
      _scrollToBottom();
    } catch (e) {
      print("Error submitting comment: $e");
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding around the entire widget
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Rating Section
          AddRatingWidget(
            contentId: widget.contentId,
            contentType: widget.contentType,
          ), // This is the rating widget

          SizedBox(height: 16), // Space between the rating and comments

          // Add Comment Section
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0), // Added more bottom padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add a comment:", style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 8), // Space between text and input field
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Write your comment here...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // More padding inside the text field
                        ),
                        maxLines: 3,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _submitComment(_commentController.text),
                      icon: Icon(Icons.send, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Show Comments Section
          Expanded(
            child: FutureBuilder<List<Comment>?>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(child: Text('No comments yet. Be the first to comment!'));
                }

                final comments = snapshot.data!;
                final reversedComments = comments.reversed.toList();

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: reversedComments.length,
                  itemBuilder: (context, index) {
                    final comment = reversedComments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0), // Padding for each comment card
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16), // Padding inside the card
                          title: Text(
                            comment.userName,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0), // Padding between comment text and date
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comment.text, style: TextStyle(fontSize: 14, color: Colors.black87)),
                                SizedBox(height: 6), // Space between comment and date
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "${comment.createdTime.toLocal()}".split(' ')[0],
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
