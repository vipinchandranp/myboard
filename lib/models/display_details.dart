import 'dart:math';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class DisplayDetails {
  final String id;
  final double latitude;
  final double longitude;
  final String description;
  final List<Comment> comments;
  final double rating;
  final String userId;
  final List<XFile>? images; // Add a list of images
  // Define a list of image paths from your asset folder
  static const List<String> assetImagePaths = [
    'assets/canvas.jpg',
    'assets/myboard_logo1.png',
    'assets/myboard_logo2.png',
    // Add more paths as needed
  ];

  DisplayDetails({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.comments,
    required this.rating,
    required this.userId,
    this.images,
  });

  factory DisplayDetails.fromJson(Map<String, dynamic> json) {
    return DisplayDetails(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      description: json['description'],
      comments: json['comments'] != null
          ? List<Comment>.from(
              json['comments'].map((comment) => Comment.fromJson(comment)))
          : [],
      rating: json['rating'],
      userId: json['userId'],
      images: json['images'] != null
          ? List<XFile>.from(
              json['images'].map((imagePath) => XFile(imagePath)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'rating': rating,
      'userId': userId,
      'images': images?.map((image) => image.path).toList(),
    };
  }

  factory DisplayDetails.fromDateTimeSlot() {
    final random = Random();
    final displayId =
        'display${random.nextInt(1000)}'; // Generate a random display id

    // Select a random image path from the assetImagePaths list
    final String randomImagePath =
    assetImagePaths[random.nextInt(assetImagePaths.length)];

    // Generate dummy comments
    final List<Comment> dummyComments = List.generate(
      random.nextInt(5) + 1, // Generate between 1 to 5 comments
          (index) => Comment(
        text: 'Comment $index',
        username: 'User${random.nextInt(100)}',
        date: DateTime.now().subtract(Duration(days: index)),
        replies: List.generate(
          random.nextInt(3), // Generate between 0 to 3 replies for each comment
              (replyIndex) => Reply(
            text: 'Reply $replyIndex',
            username: 'User${random.nextInt(100)}',
            date: DateTime.now().subtract(Duration(days: replyIndex)),
          ),
        ),
      ),
    );

    // Generate a random rating in terms of 5 stars
    final double randomRating = random.nextDouble() * 5;

    return DisplayDetails(
      id: displayId,
      latitude: random.nextDouble() * 180 - 90,
      longitude: random.nextDouble() * 360 - 180,
      description: 'Default Description',
      comments: dummyComments,
      rating: randomRating,
      userId: 'defaultUserId',
      // Assign the selected image path to the images list
      images: [XFile(randomImagePath)],
    );
  }

}

class Comment {
  final String text;
  final String username;
  final DateTime date;
  final List<Reply> replies;

  Comment({
    required this.text,
    required this.username,
    required this.date,
    required this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      text: json['text'],
      username: json['username'],
      date: DateTime.parse(json['date']),
      replies: json['replies'] != null
          ? List<Reply>.from(
              json['replies'].map((reply) => Reply.fromJson(reply)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'username': username,
      'date': date.toIso8601String(),
      'replies': replies.map((reply) => reply.toJson()).toList(),
    };
  }
}

class Reply {
  final String text;
  final String username;
  final DateTime date;

  Reply({
    required this.text,
    required this.username,
    required this.date,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      text: json['text'],
      username: json['username'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'username': username,
      'date': date.toIso8601String(),
    };
  }
}
