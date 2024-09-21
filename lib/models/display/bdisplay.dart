
import '../common/media_file.dart';
import 'display_media_file.dart';

class BDisplay {
  final String displayId;
  final String displayName;
  final DateTime createdDateAndTime;
  List<MediaFile> mediaFiles;
  final String status;

  BDisplay({
    required this.displayId,
    required this.displayName,
    required this.createdDateAndTime,
    this.mediaFiles = const [], // Provide a default empty list
    required this.status,
  });

  // Factory method to create a Board instance from JSON data
  factory BDisplay.fromJson(Map<String, dynamic> json) {
    // Safely check if 'createdDateAndTime' is a valid string before parsing
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(json['createdDateAndTime']?.toString() ?? '');
    } catch (e) {
      // If parsing fails, use DateTime.now() as a fallback
      parsedDate = DateTime.now();
    }

    return BDisplay(
      displayId: json['displayId'] ?? 'unknown', // Provide a default if boardId is null
      displayName: json['displayName'] ?? 'Unnamed Display', // Provide a default if boardName is null
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
      'displayId': displayId,
      'displayName': displayName,
      'createdDateAndTime': createdDateAndTime.toIso8601String(),
      'mediaFiles': mediaFiles.map((media) => media.toJson()).toList(),
      'status': status,
    };
  }
}
