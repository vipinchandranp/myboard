import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Board {
  final String? id; // Add id parameter
  final String userId; // Add userId parameter
  final String title;
  final String description;
  final List<DateTimeSlot> displayDetails;

  Board({
    this.id, // Add id parameter
    required this.userId, // Add userId parameter
    required this.title,
    required this.description,
    this.displayDetails = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Board &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory Board.fromJson(Map<String, dynamic> json) {
    final displayDetails = json['displayDetails'];

    // Check if the displayDetails is null or empty
    if (displayDetails == null || displayDetails.isEmpty) {
      return Board(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        description: json['description'],
        displayDetails: [],
      );
    }

    final displayDetailsList = List<Map<String, dynamic>>.from(displayDetails);
    final List<DateTimeSlot> dateTimeSlots =
    displayDetailsList.map((data) => DateTimeSlot.fromJson(data)).toList();

    return Board(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      displayDetails: dateTimeSlots,
    );
  }

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> displayDetailsJson =
    displayDetails.map((dateTimeSlot) => dateTimeSlot.toJson()).toList();

    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'displayDetails': displayDetailsJson,
    };
  }

  Board copyWith({
    String? id, // Add id parameter
    String? userId, // Add userId parameter
    String? title,
    String? description,
    List<DateTimeSlot>? displayDetails
  }) {
    return Board(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      displayDetails: displayDetails ?? this.displayDetails,
    );
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
