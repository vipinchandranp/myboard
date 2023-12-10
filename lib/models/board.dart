import 'package:flutter/material.dart';

class Board {
  String? _id; // Add id parameter
  String? _userId; // Add userId parameter
  String? _title;
  String? _description;
  int? _rating;
  List<Comment>? _comments;
  List<DateTimeSlot>? _displayDetails;

  Board(
      {String? id,
      String? userId,
      String? title,

      String? description,
      int? rating,
      List<Comment>? comments,
      List<DateTimeSlot>? displayDetails})
      : _id = id,
        _userId = userId,
        _title = title,
        _description = description,
        _rating = rating,
        _comments = comments,
        _displayDetails = displayDetails;


  String? get id => _id;

  set id(String? id){
    _id = id;
  }

  int? get rating => _rating;

  set rating(int? rating) {
    _rating = rating;
  }

  String? get userId => _userId;

  set userId(String? userId) {
    _userId = userId;
  }

  String? get title => _title;

  set title(String? title) {
    _title = title;
  }

  String? get description => _description;

  set description(String? description) {
    _description = description;
  }

  List<Comment>? get comments => _comments;

  set comments(List<Comment>? comments) {
    _comments = comments;
  }

  List<DateTimeSlot>? get displayDetails => _displayDetails;

  set displayDetails(List<DateTimeSlot>? displayDetails) {
    _displayDetails = displayDetails;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'userId': _userId,
      'title': _title,
      'description': _description,
      'rating': _rating,
      'comments': _comments?.map((comment) => comment.toJson()).toList(),
      'displayDetails': _displayDetails?.map((dateTimeSlot) => dateTimeSlot.toJson()).toList(),
    };
  }

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board()
      ..id = json['id']
      ..userId = json['userId']
      ..title = json['title']
      ..description = json['description']
      ..rating = json['rating'] // Updated data type to int
      ..comments = json['comments'] != null
          ? List<Comment>.from(json['comments'].map((comment) => Comment.fromJson(comment)))
          : []
      ..displayDetails = json['displayDetails'] != null
          ? List<DateTimeSlot>.from(json['displayDetails'].map((slot) => DateTimeSlot.fromJson(slot)))
          : [];
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

class DateTimeSlot {
  final String? id;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String display;
  final String username;

  DateTimeSlot({
    this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.display,
    required this.username,
  });

  factory DateTimeSlot.fromJson(Map<String, dynamic> json) {
    return DateTimeSlot(
      id: json['id'],
      date: DateTime.parse(json['date']),
      startTime: _parseTime(json['startTime']),
      endTime: _parseTime(json['endTime']),
      display: json['display'],
      username: json['username'],
    );
  }

  static TimeOfDay _parseTime(String timeString) {
    final timeParts = timeString.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'startTime': _formatTime(startTime),
      'endTime': _formatTime(endTime),
      'display': display,
      'username': username,
    };
  }

  static String _formatTime(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }
}
