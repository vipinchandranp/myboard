import 'dart:convert';  // Import for base64 decoding
import 'dart:typed_data';  // For handling byte arrays (Uint8List)

class TimeSlotBoardToBePlayed {
  final String timeslotId;
  final String boardId;
  final String displayId;
  final String boardName;
  final String displayName;
  final String boardMediaPath;  // updated field name
  final Uint8List? displayQrCode; // Using Uint8List for byte arrays
  final String message;

  final String startTime;  // Start time for the board
  final String endTime;    // End time for the board

  // Constructor
  TimeSlotBoardToBePlayed({
    required this.timeslotId,
    required this.boardId,
    required this.displayId,
    required this.boardName,
    required this.displayName,
    required this.boardMediaPath, // updated field name
    this.displayQrCode, // Nullable to account for optional QR code
    required this.message,
    required this.startTime, // Start time
    required this.endTime,   // End time
  });

  // Factory method to create an instance of TimeSlotBoardToBePlayed from JSON
  factory TimeSlotBoardToBePlayed.fromJson(Map<String, dynamic> json) {
    Uint8List? qrCodeBytes;
    if (json['displayQrCode'] != null) {
      if (json['displayQrCode'] is String) {
        // Decode base64 string to Uint8List
        qrCodeBytes = base64Decode(json['displayQrCode']);
      } else if (json['displayQrCode'] is List) {
        // Convert List<int> to Uint8List
        qrCodeBytes = Uint8List.fromList(List<int>.from(json['displayQrCode']));
      }
    }

    return TimeSlotBoardToBePlayed(
      timeslotId: json['timeslotId'] ?? 'N/A',
      boardId: json['boardId'] ?? 'N/A',
      displayId: json['displayId'] ?? 'N/A',
      boardName: json['boardName'] ?? 'N/A',
      displayName: json['displayName'] ?? 'N/A',
      boardMediaPath: json['boardMediaPath'] ?? 'N/A', // updated field name
      displayQrCode: qrCodeBytes, // Handle byte array
      message: json['message'] ?? 'N/A',
      startTime: json['startTime'] ?? 'N/A', // Start time
      endTime: json['endTime'] ?? 'N/A',     // End time
    );
  }

  // Method to convert TimeSlotBoardToBePlayed to JSON format
  Map<String, dynamic> toJson() {
    return {
      'timeslotId': timeslotId,
      'boardId': boardId,
      'displayId': displayId,
      'boardName': boardName,
      'displayName': displayName,
      'boardMediaPath': boardMediaPath, // updated field name
      'displayQrCode': displayQrCode?.toList(), // Convert Uint8List to List<int>
      'message': message,
      'startTime': startTime,  // Add start time to JSON
      'endTime': endTime,      // Add end time to JSON
    };
  }
}
