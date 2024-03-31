import 'package:flutter/material.dart';

class DisplayTimeSlot {
  final String id;
  final String displayId;
  final String boardId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool approved;

  DisplayTimeSlot({
    required this.id,
    required this.displayId,
    required this.boardId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.approved,
  });

  factory DisplayTimeSlot.fromJson(Map<String, dynamic> json) {
    return DisplayTimeSlot(
      id: json['id'] ?? '',
      displayId: json['displayId'] ?? '',
      boardId: json['boardId'] ?? '',
      date: DateTime.parse(json['date'] ?? ''),
      startTime: _parseTime(json['startTime'] ?? ''),
      endTime: _parseTime(json['endTime'] ?? ''),
      approved: json['approved'] ?? false,
    );
  }

  static TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
