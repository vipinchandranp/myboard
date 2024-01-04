import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myboard/models/display_details.dart';

class Board {
  String? _id;
  String? _userId;
  String? _title;
  String? _description;
  int? _rating;
  List<Comment>? _comments;
  List<DisplayDetails>? _displayDetails;
  List<DateTimeSlot>? _dateTimeSlots; // Added this line for DateTimeSlot
  bool? _isApproved;
  XFile? _imageFile;

  Board({
    String? id,
    String? userId,
    String? title,
    String? description,
    int? rating,
    List<Comment>? comments,
    List<DisplayDetails>? displayDetails,
    List<DateTimeSlot>? dateTimeSlots, // Added this line for DateTimeSlot
    bool? isApproved,
    XFile? imageFile,
  })  : _id = id,
        _userId = userId,
        _title = title,
        _description = description,
        _rating = rating,
        _comments = comments,
        _displayDetails = displayDetails,
        _dateTimeSlots = dateTimeSlots,
        // Added this line for DateTimeSlot
        _isApproved = isApproved,
        _imageFile = imageFile;

  String? get id => _id;

  set id(String? id) {
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

  List<DisplayDetails>? get displayDetails => _displayDetails;

  set displayDetails(List<DisplayDetails>? displayDetails) {
    _displayDetails = displayDetails;
  }

  List<DateTimeSlot>? get dateTimeSlots =>
      _dateTimeSlots; // Added this line for DateTimeSlot

  set dateTimeSlots(List<DateTimeSlot>? dateTimeSlots) {
    _dateTimeSlots = dateTimeSlots;
  }

  bool? get isApproved => _isApproved;

  set isApproved(bool? isApproved) {
    _isApproved = isApproved;
  }

  XFile? get imageFile => _imageFile;

  set imageFile(XFile? imageFile) {
    _imageFile = imageFile;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'userId': _userId,
      'title': _title,
      'description': _description,
      'rating': _rating,
      'comments': _comments?.map((comment) => comment.toJson()).toList(),
      'displayDetails':
          _displayDetails?.map((display) => display.toJson()).toList(),
      'dateTimeSlots':
          _dateTimeSlots?.map((dateTimeSlot) => dateTimeSlot.toJson()).toList(),
      // Added this line for DateTimeSlot
      'isApproved': _isApproved,
      'imageFile': _imageFile?.path,
    };
  }

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      rating: json['rating'],
      comments: json['comments'] != null
          ? List<Comment>.from(
              json['comments'].map((comment) => Comment.fromJson(comment)))
          : [],
      displayDetails: json['displayDetails'] != null
          ? List<DisplayDetails>.from(json['displayDetails']
              .map((display) => DisplayDetails.fromJson(display)))
          : [],
      dateTimeSlots:
          json['dateTimeSlots'] != null // Added this line for DateTimeSlot
              ? List<DateTimeSlot>.from(json['dateTimeSlots']
                  .map((dateTimeSlot) => DateTimeSlot.fromJson(dateTimeSlot)))
              : [],
      // Added this line for DateTimeSlot
      isApproved: json['isApproved'],
      imageFile: json['imageFile'] != null ? XFile(json['imageFile']) : null,
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

class DateTimeSlot {
  final String? id;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String display;
  final String username;
  final double? latitude;
  final double? longitude;

  DateTimeSlot({
    this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.display,
    required this.username,
    this.latitude,
    this.longitude,
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
