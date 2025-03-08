import 'package:flutter/material.dart';

import '../../utils/ItemType.dart';

class RatingWidget extends StatefulWidget {
  final String contentId;
  final ItemType contentType;

  RatingWidget({required this.contentId, required this.contentType});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _currentRating = 0.0; // Default value, which seems to be the problem

  @override
  void initState() {
    super.initState();
    // Initialize _currentRating to a valid range value (e.g., 1.0)
    // If you're fetching it from a backend, ensure it's within the range 1.0 to 5.0
    _currentRating = _currentRating.clamp(1.0, 5.0); // Ensure value is within the valid range
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Rate this content'),
        Slider(
          value: _currentRating,
          min: 1.0,
          max: 5.0,
          divisions: 4,
          label: _currentRating.toString(),
          onChanged: (double value) {
            setState(() {
              _currentRating = value.clamp(1.0, 5.0); // Clamping value to valid range
            });
          },
        ),
        Text('Rating: $_currentRating'),
      ],
    );
  }
}
