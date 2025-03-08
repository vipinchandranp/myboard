import 'package:flutter/material.dart';
import '../../models/common/comment.dart';
import '../../repository/display_repository.dart';
import '../../repository/board_repository.dart';
import '../../utils/ItemType.dart';

class ShowComments extends StatefulWidget {
  final String contentId;
  final ItemType contentType;

  const ShowComments({
    Key? key,
    required this.contentId,
    required this.contentType,
  }) : super(key: key);

  @override
  _ShowCommentsState createState() => _ShowCommentsState();
}

class _ShowCommentsState extends State<ShowComments> {
  late Future<List<Comment>?> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = _fetchComments(widget.contentId, widget.contentType);
  }

  // Fetch comments based on contentId and contentType (Display or Board)
  Future<List<Comment>?> _fetchComments(String contentId, ItemType contentType) async {
    try {
      if (contentType == ItemType.DISPLAY) {
        // Fetch comments for Display content
        return await DisplayService(context).getComments(contentId);
      } else if (contentType == ItemType.BOARD) {
        // Fetch comments for Board content
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Comment>?>(
      future: _commentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Oops! Something went wrong.'));
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: Text('No comments yet. Be the first to comment!'));
        }

        final comments = snapshot.data!;

        return Scrollbar( // Add Scrollbar widget
          thumbVisibility: true, // You can change this to false if you only want the scrollbar when the list is long enough
          child: ListView.builder(
            padding: EdgeInsets.all(10),  // Padding for the ListView
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];

              return Card(
                margin: EdgeInsets.only(bottom: 10),  // Card margin for spacing between comments
                elevation: 3,  // Elevation for a subtle shadow effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),  // Rounded corners for the card
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),  // Inner padding for the ListTile
                  title: Text(
                    comment.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,  // Slightly bigger font for the username
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),  // Adding some space between comment text and date
                      Text(
                        comment.text,
                        style: TextStyle(
                          fontSize: 14,  // Font size for the comment text
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "${comment.createdTime.toLocal()}".split(' ')[0],  // Showing only date (can format further)
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
