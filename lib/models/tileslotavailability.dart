class TimeSlotAvailability {
  final DateTime selectedDate;
  final List<String> availableTimeSlots;
  final List<String> unavailableTimeSlots;

  TimeSlotAvailability({
    required this.selectedDate,
    required this.availableTimeSlots,
    required this.unavailableTimeSlots,
  });

  factory TimeSlotAvailability.fromJson(Map<String, dynamic> json) {
    return TimeSlotAvailability(
      selectedDate: DateTime.parse(json['selectedDate']),
      availableTimeSlots: List<String>.from(json['availableTimeSlots']),
      unavailableTimeSlots: List<String>.from(json['unavailableTimeSlots']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedDate': selectedDate.toIso8601String(),
      'availableTimeSlots': availableTimeSlots,
      'unavailableTimeSlots': unavailableTimeSlots,
    };
  }
}
