import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DisplayDetails {
  final String id;
  final double latitude;
  final double longitude;
  final String? description;
  final List<Comment>? comments;
  final double? rating;
  final String? userId;
  final String displayName;
  final List<XFile>? images;
  final String userName;
  final String? fileName;

  DisplayDetails({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.description,
    this.comments,
    this.rating,
    this.userId,
    required this.displayName,
    this.images,
    required this.userName,
    this.fileName,
  });

  factory DisplayDetails.fromJson(Map<String, dynamic> json) {
    return DisplayDetails(
      id: json['id'] ?? '',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      description: json['description'],
      comments: json['comments'] != null
          ? List<Comment>.from(
              (json['comments'] as List<dynamic>)
                  .map((comment) => Comment.fromJson(comment)),
            )
          : null,
      rating: json['rating']?.toDouble(),
      userId: json['userId'],
      displayName: json['displayName'] ?? '',
      images: json['images'] != null
          ? List<XFile>.from(
              (json['images'] as List<dynamic>)
                  .map((imagePath) => XFile(imagePath.toString())),
            )
          : null,
      userName: json['userName'] ?? '',
      fileName: json['fileName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'comments': comments?.map((comment) => comment.toJson()).toList(),
      'rating': rating,
      'userId': userId,
      'displayName': displayName,
      'images': images?.map((image) => image?.path).toList(),
      // Handle null image paths
      'userName': userName,
      'fileName': fileName,
    }..removeWhere(
        (key, value) => value == null); // Remove null values from the map
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
