import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Board {
  final String? id; // Add id parameter
  final String userId; // Add userId parameter
  final String title;
  final String description;
  final Map<String, DateTimeSlot> displayDateTimeMap;
  final List<String> selectedDisplays;

  Board({
    this.id, // Add id parameter
    required this.userId, // Add userId parameter
    required this.title,
    required this.description,
    this.displayDateTimeMap = const {},
    this.selectedDisplays = const [],
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    final displayDateTimeMapJson = json['displayDateTimeMap'];

    // Check if the displayDateTimeMapJson is null or empty
    if (displayDateTimeMapJson == null || displayDateTimeMapJson.isEmpty) {
      return Board(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        description: json['description'],
        displayDateTimeMap: {},
      );
    }

    final displayDateTimeMap = <String, DateTimeSlot>{};

    displayDateTimeMapJson.forEach((key, value) {
      final dateTimeSlotJson = value as Map<String, dynamic>;
      final dateTimeSlot = DateTimeSlot.fromJson(dateTimeSlotJson);
      displayDateTimeMap[key] = dateTimeSlot;
    });

    return Board(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      displayDateTimeMap: displayDateTimeMap,
    );
  }

  Map<String, dynamic> toJson() {
    final displayDateTimeMapJson =
        Map<String, dynamic>.from(displayDateTimeMap.map(
      (key, value) => MapEntry(key, {
        'date': value.date.toIso8601String(),
        'startTime':
            '${value.startTime.hour.toString().padLeft(2, '0')}:${value.startTime.minute.toString().padLeft(2, '0')}',
        'endTime':
            '${value.endTime.hour.toString().padLeft(2, '0')}:${value.endTime.minute.toString().padLeft(2, '0')}',
        'display': value.display,
      }),
    ));

    return {
      'userId': userId,
      'title': title,
      'description': description,
      'displayDateTimeMap': displayDateTimeMapJson,
    };
  }

  Board copyWith({
    String? id, // Add id parameter
    String? userId, // Add userId parameter
    String? title,
    String? description,
    Map<String, DateTimeSlot>? displayDateTimeMap,
    List<String>? selectedDisplays,
  }) {
    return Board(
      id: id ?? this.id,
      // Add id parameter
      userId: userId ?? this.userId,
      // Add userId parameter
      title: title ?? this.title,
      description: description ?? this.description,
      displayDateTimeMap: displayDateTimeMap ?? this.displayDateTimeMap,
      selectedDisplays: selectedDisplays ?? this.selectedDisplays,
    );
  }

  Board updateDateTimeSlot(String display, DateTimeSlot dateTimeSlot) {
    final updatedMap = Map<String, DateTimeSlot>.from(displayDateTimeMap);
    updatedMap[display] = dateTimeSlot;
    return copyWith(displayDateTimeMap: updatedMap);
  }
}

class DateTimeSlot {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String display;
  final String? username;

  DateTimeSlot({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.display,
    this.username,
  });

  factory DateTimeSlot.fromJson(Map<String, dynamic> json) {
    final timeFormatter = DateFormat('HH:mm');
    return DateTimeSlot(
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
