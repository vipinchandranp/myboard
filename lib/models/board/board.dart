import '../common/media_file.dart';

class Board {
  final String boardId;
  final String boardName;
  final DateTime createdDateAndTime;
  List<MediaFile> mediaFiles;
  final String status;

  Board({
    required this.boardId,
    required this.boardName,
    required this.createdDateAndTime,
    this.mediaFiles = const [],
    required this.status,
  });

  // Factory method to create a Board instance from JSON data
  factory Board.fromJson(Map<String, dynamic> json) {
    // Safely check if 'createdDateAndTime' is a valid string before parsing
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(json['createdDateAndTime']?.toString() ?? '');
    } catch (e) {
      // If parsing fails, use DateTime.now() as a fallback
      parsedDate = DateTime.now();
    }

    return Board(
      boardId: json['boardId'] ?? 'unknown', // Provide a default if boardId is null
      boardName: json['boardName'] ?? 'Unnamed Board', // Provide a default if boardName is null
      createdDateAndTime: parsedDate,
      mediaFiles: (json['mediaFiles'] as List?)
          ?.map((mediaJson) => MediaFile.fromJson(mediaJson))
          .toList() ?? [],
      status: json['status'] ?? 'unknown', // Provide a default if status is null
    );
  }

  // Convert a Board instance into JSON
  Map<String, dynamic> toJson() {
    return {
      'boardId': boardId,
      'boardName': boardName,
      'createdDateAndTime': createdDateAndTime.toIso8601String(),
      'mediaFiles': mediaFiles.map((media) => media.toJson()).toList(),
      'status': status,
    };
  }
}
