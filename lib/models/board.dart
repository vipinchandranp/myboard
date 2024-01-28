import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Board {
  String? _id;
  String? _userId;
  String? _title;
  String? _description;
  int? _rating;
  List<Comment>? _comments;
  List<BoardDisplayDetails>? _displayDetails; // Updated this line
  bool? _isApproved;
  XFile? _imageFile;

  Board({
    String? id,
    String? userId,
    String? title,
    String? description,
    int? rating,
    List<Comment>? comments,
    List<BoardDisplayDetails>? displayDetails, // Updated this line
    bool? isApproved,
    XFile? imageFile,
  })  : _id = id,
        _userId = userId,
        _title = title,
        _description = description,
        _rating = rating,
        _comments = comments,
        _displayDetails = displayDetails, // Updated this line
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

  List<BoardDisplayDetails>? get displayDetails =>
      _displayDetails; // Updated this line

  set displayDetails(List<BoardDisplayDetails>? displayDetails) {
    _displayDetails = displayDetails;
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
          ? List<BoardDisplayDetails>.from(json['displayDetails']
          .map((display) => BoardDisplayDetails.fromJson(display)))
          : [],
      isApproved: json['isApproved'],
      imageFile: json['imageFile'] != null ? XFile(json['imageFile']) : null,
    );
  }
}

class BoardDisplayDetails {
  String? _id;
  String? _name;
  List<DateTimeSlot>? _dateTimeSlots;

  BoardDisplayDetails({
    String? id,
    String? name,
    List<DateTimeSlot>? dateTimeSlots,
  })  : _id = id,
        _name = name,
        _dateTimeSlots = dateTimeSlots;

  String? get id => _id;

  set id(String? id) {
    _id = id;
  }

  String? get name => _name;

  set name(String? name) {
    _name = name;
  }

  List<DateTimeSlot>? get dateTimeSlots => _dateTimeSlots;

  set dateTimeSlots(List<DateTimeSlot>? dateTimeSlots) {
    _dateTimeSlots = dateTimeSlots;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'dateTimeSlots':
      _dateTimeSlots?.map((dateTimeSlot) => dateTimeSlot.toJson()).toList(),
    };
  }

  factory BoardDisplayDetails.fromJson(Map<String, dynamic> json) {
    return BoardDisplayDetails(
      id: json['id'],
      name: json['name'],
      dateTimeSlots: json['dateTimeSlots'] != null
          ? List<DateTimeSlot>.from(json['dateTimeSlots']
          .map((dateTimeSlot) => DateTimeSlot.fromJson(dateTimeSlot)))
          : [],
    );
  }
}

class DateTimeSlot {
  String? _id;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  DateTimeSlot({
    String? id,
    DateTime? selectedDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  })  : _id = id,
        _selectedDate = selectedDate,
        _startTime = startTime,
        _endTime = endTime;

  String? get id => _id;

  set id(String? id) {
    _id = id;
  }

  DateTime? get selectedDate => _selectedDate;

  set selectedDate(DateTime? selectedDate) {
    _selectedDate = selectedDate;
  }

  TimeOfDay? get startTime => _startTime;

  set startTime(TimeOfDay? startTime) {
    _startTime = startTime;
  }

  TimeOfDay? get endTime => _endTime;

  set endTime(TimeOfDay? endTime) {
    _endTime = endTime;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'selectedDate': _selectedDate?.toIso8601String(),
      'startTime': _formatTimeOfDay(_startTime),
      'endTime': _formatTimeOfDay(_endTime),
    };
  }

  factory DateTimeSlot.fromJson(Map<String, dynamic> json) {
    return DateTimeSlot(
      id: json['id'],
      selectedDate: json['selectedDate'] != null
          ? DateTime.parse(json['selectedDate'])
          : null,
      startTime: _parseTimeOfDay(json['startTime']),
      endTime: _parseTimeOfDay(json['endTime']),
    );
  }

  static TimeOfDay? _parseTimeOfDay(String? timeString) {
    if (timeString == null || timeString.isEmpty) {
      return null;
    }
    final timeParts = timeString.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  static String? _formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) {
      return null;
    }
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
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
