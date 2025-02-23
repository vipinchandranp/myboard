import 'package:flutter/material.dart';
import '../../repository/board_repository.dart';
import '../../repository/display_repository.dart';
import '../../utils/content_type.dart';

class AddRatingWidget extends StatefulWidget {
  final String contentId;  // The ID of the content to be rated
  final MBContentType contentType;  // The type of content (e.g., MBContentType.BOARD, MBContentType.DISPLAY)

  AddRatingWidget({required this.contentId, required this.contentType});

  @override
  _AddRatingWidgetState createState() => _AddRatingWidgetState();
}

class _AddRatingWidgetState extends State<AddRatingWidget> {
  double _rating = 0.0;
  bool _isSubmitting = false;

  // Method to submit the rating
  Future<void> _submitRating() async {
    if (_rating == 0.0) {
      // If the user hasn't selected a rating, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    String? result;

    // Call the appropriate service based on the content type
    if (widget.contentType == MBContentType.BOARD) {
      result = await BoardService(context).addRating(widget.contentId, _rating);
    } else if (widget.contentType == MBContentType.DISPLAY) {
      result = await DisplayService(context).addRating(widget.contentId, _rating);
    }

    setState(() {
      _isSubmitting = false;
    });

    // Show a message based on the result
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit rating')),
      );
    }
  }

  // Build a row of stars for rating selection
  Widget buildStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          icon: Icon(
            starIndex <= _rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              _rating = starIndex.toDouble();
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rate ${widget.contentType == MBContentType.BOARD ? 'Board' : 'Display'}:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          buildStars(),
          SizedBox(height: 16),
          _isSubmitting
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
            onPressed: _submitRating,
            child: Text('Submit Rating'),
          ),
        ],
      ),
    );
  }
}
