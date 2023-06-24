import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    return Board(
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
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

  DateTimeSlot({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.display,
  });
}
