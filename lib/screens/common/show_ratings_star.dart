import 'package:flutter/material.dart';
import '../../repository/board_repository.dart';
import '../../repository/display_repository.dart';
import '../../utils/content_type.dart'; // Assuming this is where the content types are defined

class ShowRatingStarsWidget extends StatefulWidget {
  final String contentId; // The content ID (display or board)
  final MBContentType contentType; // The content type (DISPLAY or BOARD)

  const ShowRatingStarsWidget({
    Key? key,
    required this.contentId,
    required this.contentType,
  }) : super(key: key);

  @override
  _ShowRatingStarsWidgetState createState() => _ShowRatingStarsWidgetState();
}

class _ShowRatingStarsWidgetState extends State<ShowRatingStarsWidget> {
  double _rating = 0.0; // To store the rating out of 5
  bool _isLoading = true; // To show a loading state while fetching the rating

  @override
  void initState() {
    super.initState();
    _fetchRating();
  }

  // Fetch the rating for the given content (Display or Board)
  Future<void> _fetchRating() async {
    try {
      double rating = 0.0;

      if (widget.contentType == MBContentType.DISPLAY) {
        rating = await DisplayService(context).getDisplayRating(widget.contentId) ?? 0.0;
      } else if (widget.contentType == MBContentType.BOARD) {
        rating = await BoardService(context).getBoardRating(widget.contentId) ?? 0.0;
      }

      setState(() {
        _rating = rating;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator() // Show a loading indicator if the rating is still being fetched
        : Row(
      mainAxisSize: MainAxisSize.min,
      children: _buildStars(),
    );
  }

  // Build the stars based on the rating
  List<Widget> _buildStars() {
    List<Widget> stars = [];

    for (int i = 1; i <= 5; i++) {
      if (_rating >= i) {
        stars.add(Icon(
          Icons.star,
          size: 24.0,
          color: Colors.yellow,
        ));
      } else if (_rating >= i - 0.5) {
        stars.add(Icon(
          Icons.star_half,
          size: 24.0,
          color: Colors.yellow,
        ));
      } else {
        stars.add(Icon(
          Icons.star_border,
          size: 24.0,
          color: Colors.yellow,
        ));
      }
    }

    return stars;
  }
}
