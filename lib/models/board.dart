import 'package:flutter/foundation.dart';

class Board {
  final String title;
  final String description;
  final DateTimeSlot? dateTimeSlot;

  Board({
    required this.title,
    required this.description,
    this.dateTimeSlot,
  });

  Board copyWith({
    String? title,
    String? description,
    DateTimeSlot? dateTimeSlot,
  }) {
    return Board(
      title: title ?? this.title,
      description: description ?? this.description,
      dateTimeSlot: dateTimeSlot ?? this.dateTimeSlot,
    );
  }

  Board updateDateTimeSlot(DateTimeSlot dateTimeSlot) {
    return Board(
      title: title,
      description: description,
      dateTimeSlot: dateTimeSlot,
    );
  }
}

class DateTimeSlot {
  final DateTime date;
  final String timeSlot;

  DateTimeSlot({
    required this.date,
    required this.timeSlot,
  });
}
