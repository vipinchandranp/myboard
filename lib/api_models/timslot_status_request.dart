class TimeslotStatusRequest {
  DateTime date;
  String? displayId;
  String? displayName;
  String? boardId;
  String? boardName;
  String? status; // You might want to use an enum for this

  TimeslotStatusRequest({
    required this.date,
    this.displayId,
    this.displayName,
    this.boardId,
    this.boardName,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'displayId': displayId,
      'displayName': displayName,
      'boardId': boardId,
      'boardName': boardName,
      'status': status,
    };
  }
}
