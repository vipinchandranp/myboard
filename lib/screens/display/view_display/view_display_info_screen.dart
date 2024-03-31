import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/repositories/display_repository.dart';

class DisplayDetailsPopup extends StatefulWidget {
  final DisplayDetails displayDetails;

  DisplayDetailsPopup({required this.displayDetails});

  @override
  _DisplayDetailsPopupState createState() => _DisplayDetailsPopupState();
}

class _DisplayDetailsPopupState extends State<DisplayDetailsPopup> {
  late Future<List<int>> displayImage;

  @override
  void initState() {
    super.initState();
    displayImage =
        DisplayRepository().getDisplayImage(widget.displayDetails.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: displayImage,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null) {
          return Text('No data available');
        } else {
          DisplayDetails displayDetails = widget.displayDetails;
          return buildPopupBody(displayDetails, snapshot.data!);
        }
      },
    );
  }

  @override
  Widget buildPopupBody(DisplayDetails displayDetails, List<int> imageBytes) {
    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayDetails.id ?? 'ID',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                displayDetails.description ?? 'Description',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16.0),
              Text(
                'Rating: ${displayDetails.rating!.toStringAsFixed(1)}/5',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16.0),
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                items: [_buildImage(imageBytes)],
              ),
              SizedBox(height: 16.0),
              Text(
                'Comments:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              displayDetails.comments != null
                  ? _buildCommentsList(displayDetails.comments!)
                  : Text('No comments available'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(List<int> imageBytes) {
    return Image.memory(Uint8List.fromList(imageBytes), fit: BoxFit.cover);
  }

  Widget _buildCommentsList(List<Comment> comments) {
    return Column(
      children: comments.map((comment) => _buildComment(comment)).toList(),
    );
  }

  Widget _buildComment(Comment comment) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${comment.username} - ${comment.date.toLocal()}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            comment.text,
            style: TextStyle(fontSize: 14),
          ),
          _buildRepliesList(comment.replies),
        ],
      ),
    );
  }

  Widget _buildRepliesList(List<Reply> replies) {
    return replies.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: replies.map((reply) => _buildReply(reply)).toList(),
          )
        : SizedBox.shrink();
  }

  Widget _buildReply(Reply reply) {
    return Container(
      margin: EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${reply.username} - ${reply.date.toLocal()}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            reply.text,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
