import '../common/media_file.dart';

class Board {
  final String boardId;
  final String boardName;
  final DateTime createdDateAndTime;
  List<MediaFile> mediaFiles;
  final String status;

  // Transient properties for tracking user's reaction
  bool likedByCurrentUser;
  bool dislikedByCurrentUser;

  // Fields for the number of likes and dislikes
  int numberOfLikes;
  int numberOfDislikes;

  Board({
    required this.boardId,
    required this.boardName,
    required this.createdDateAndTime,
    this.mediaFiles = const [],
    required this.status,
    this.likedByCurrentUser = false,
    this.dislikedByCurrentUser = false,
    this.numberOfLikes = 0,
    this.numberOfDislikes = 0,
  });

  // Factory method to create a Board instance from JSON data, including transient properties.
  factory Board.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(json['createdDateAndTime']?.toString() ?? '');
    } catch (e) {
      parsedDate = DateTime.now();
    }

    return Board(
      boardId: json['boardId'] ?? 'unknown',
      boardName: json['boardName'] ?? 'Unnamed Board',
      createdDateAndTime: parsedDate,
      mediaFiles: (json['mediaFiles'] as List?)
          ?.map((mediaJson) => MediaFile.fromJson(mediaJson))
          .toList() ?? [],
      status: json['status'] ?? 'unknown',
      likedByCurrentUser: json['likedByCurrentUser'] ?? false,
      dislikedByCurrentUser: json['dislikedByCurrentUser'] ?? false,
      numberOfLikes: json['numberOfLikes'] ?? 0,
      numberOfDislikes: json['numberOfDislikes'] ?? 0,
    );
  }

  // Convert a Board instance into JSON, including the transient and count properties.
  Map<String, dynamic> toJson() {
    return {
      'boardId': boardId,
      'boardName': boardName,
      'createdDateAndTime': createdDateAndTime.toIso8601String(),
      'mediaFiles': mediaFiles.map((media) => media.toJson()).toList(),
      'status': status,
      'likedByCurrentUser': likedByCurrentUser,
      'dislikedByCurrentUser': dislikedByCurrentUser,
      'numberOfLikes': numberOfLikes,
      'numberOfDislikes': numberOfDislikes,
    };
  }
}
