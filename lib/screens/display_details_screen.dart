import 'package:flutter/material.dart';
import 'package:myboard/models/display_details.dart';

class DisplayDetailsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy DisplayDetails object
    DisplayDetails dummyDetails = DisplayDetails(
      id: '1',
      latitude: 37.7749,
      longitude: -122.4194,
      description: 'Dummy Description',
      comments: [
        Comment(
          text: 'Nice place!',
          username: 'User 1',
          date: DateTime.now(),
          replies: [], // Assuming replies is a List<Reply>
        ),
        Comment(
          text: 'I love it!',
          username: 'User 2',
          date: DateTime.now(),
          replies: [], // Assuming replies is a List<Reply>
        ),
      ],
      rating: 4.5,
      userId: 'user1',
    );

    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location: ${dummyDetails.latitude}, ${dummyDetails.longitude}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Description: ${dummyDetails.description}'),
            SizedBox(height: 8.0),
            Text('Rating: ${dummyDetails.rating}'),
            SizedBox(height: 16.0),
            Text(
              'Comments:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: dummyDetails.comments.map((comment) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User: ${comment.username}'),
                      Text('Comment: ${comment.text}'),
                      // Change 'commentText' to 'text'
                      Text('Timestamp: ${comment.date}'),
                      // Access 'date' property
                      SizedBox(height: 8.0),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
