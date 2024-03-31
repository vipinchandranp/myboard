class TimeSlotAvailability {
  final DateTime selectedDate;
  final List<String> availableTimeSlots;
  final List<String> bookedTimeslots;

  TimeSlotAvailability({
    required this.selectedDate,
    required this.availableTimeSlots,
    required this.bookedTimeslots,
  });

  factory TimeSlotAvailability.fromJson(Map<String, dynamic> json) {
    // Parse the date string manually
    List<String> dateParts = json['selectedDate'].split('-');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);
    DateTime selectedDate = DateTime(year, month, day);

    return TimeSlotAvailability(
      selectedDate: selectedDate,
      availableTimeSlots: List<String>.from(json['availableTimeSlots'] ?? []),
      bookedTimeslots:
          List<String>.from(json['unavailableTimeSlots'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedDate': selectedDate.toIso8601String(),
      'availableTimeSlots': availableTimeSlots,
      'bookedTimeslots': bookedTimeslots,
    };
  }
}
