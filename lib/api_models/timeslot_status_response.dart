class TimeslotStatusResponse {
  final DateTime date; // The date of the timeslot
  final String timeslotId;
  final String boardId; // The ID of the associated board
  final String boardName; // The name of the associated board
  final String displayId; // The ID of the associated display
  final String displayName; // The name of the associated display
  final String status; // The status of the timeslot

  TimeslotStatusResponse({
    required this.timeslotId,
    required this.date,
    required this.boardId,
    required this.boardName,
    required this.displayId,
    required this.displayName,
    required this.status,
  });

  // Factory constructor to create an instance from a JSON object
  factory TimeslotStatusResponse.fromJson(Map<String, dynamic> json) {
    return TimeslotStatusResponse(
      date: DateTime.parse(json['date']),
      // Parse date from string
      timeslotId: json['timeslotId'],
      boardId: json['boardId'],
      boardName: json['boardName'],
      // Get board name from JSON
      displayId: json['displayId'],
      displayName: json['displayName'],
      // Get display name from JSON
      status: json['status'],
    );
  }

  // Method to convert an instance to a JSON object (useful for serialization)
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'timeslotId': timeslotId,
      'boardId': boardId,
      'boardName': boardName, // Include board name in JSON
      'displayId': displayId,
      'displayName': displayName, // Include display name in JSON
      'status': status,
    };
  }
}
