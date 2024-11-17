class TimeSlotBoardToBePlayed {
  final String boardId;
  final String boardName;
  final String boardMediaPath; // updated field name
  final String displayId;
  final String displayName;

  // Constructor
  TimeSlotBoardToBePlayed({
    required this.boardId,
    required this.boardName,
    required this.boardMediaPath, // updated field name
    required this.displayId,
    required this.displayName,
  });

  // Factory method to create an instance of TimeSlotBoardToBePlayed from JSON
  factory TimeSlotBoardToBePlayed.fromJson(Map<String, dynamic> json) {
    return TimeSlotBoardToBePlayed(
      boardId: json['boardId'] ?? 'N/A',
      boardName: json['boardName'] ?? 'N/A',
      boardMediaPath: json['boardMediaPath'] ?? 'N/A', // updated field name
      displayId: json['displayId'] ?? 'N/A',
      displayName: json['displayName'] ?? 'N/A',
    );
  }

  // Method to convert TimeSlotBoardToBePlayed to JSON format
  Map<String, dynamic> toJson() {
    return {
      'boardId': boardId,
      'boardName': boardName,
      'boardMediaPath': boardMediaPath, // updated field name
      'displayId': displayId,
      'displayName': displayName,
    };
  }
}
