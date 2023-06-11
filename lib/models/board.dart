import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Board {
  final String title;
  final String description;
  final Map<String, DateTimeSlot> displayDateTimeMap;
  final List<String> selectedDisplays;

  Board({
    required this.title,
    required this.description,
    this.displayDateTimeMap = const {},
    this.selectedDisplays = const [],
  });

  Board copyWith({
    String? title,
    String? description,
    Map<String, DateTimeSlot>? displayDateTimeMap,
    List<String>? selectedDisplays,
  }) {
    return Board(
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
