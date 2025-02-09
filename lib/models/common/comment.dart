import 'package:intl/intl.dart';

class Comment {
  final String commentId;
  final String text;
  final DateTime createdTime;
  final String profilePicName;
  final String userName;

  Comment({
    required this.commentId,
    required this.text,
    required this.createdTime,
    required this.profilePicName,
    required this.userName,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'] ?? '',
      text: json['text'] ?? '',
      createdTime: DateTime.parse(json['createdTime'] ?? DateTime.now().toIso8601String()),
      profilePicName: json['profilePicName'] ?? '',
      userName: json['userName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'text': text,
      'createdTime': createdTime.toIso8601String(),
      'profilePicName': profilePicName,
      'userName': userName,
    };
  }

  String getFormattedTime() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(createdTime);
  }
}
