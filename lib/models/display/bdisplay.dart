import '../board/board.dart';
import '../common/media_file.dart';
import 'display_media_file.dart';

class BDisplay {
  final String displayId;
  final String displayName;
  final DateTime createdDateAndTime;
  List<MediaFile> mediaFiles;
  final String status;
  List<String> boardIds; // Changed to List<String>
  final double? latitude;
  final double? longitude;

  BDisplay({
    required this.displayId,
    required this.displayName,
    required this.createdDateAndTime,
    this.mediaFiles = const [], // Provide a default empty list
    required this.status,
    this.latitude, // Optional latitude
    this.longitude, // Optional longitude
    this.boardIds = const [], // Provide a default empty list for boardIds
  });

  // Factory method to create a BDisplay instance from JSON data
  factory BDisplay.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(json['createdDateAndTime']?.toString() ?? '');
    } catch (e) {
      parsedDate = DateTime.now(); // Fallback to current date if parsing fails
    }

    return BDisplay(
      displayId: json['displayId'] ?? 'unknown',
      displayName: json['displayName'] ?? 'Unnamed Display',
      createdDateAndTime: parsedDate,
      mediaFiles: (json['mediaFiles'] as List?)
              ?.map((mediaJson) => MediaFile.fromJson(mediaJson))
              .toList() ??
          [],
      status: json['status'] ?? 'unknown',
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      // Ensure correct type
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      // Ensure correct type
      boardIds:
          (json['boardIds'] as List?)?.map((id) => id.toString()).toList() ??
              [], // Handle boardIds
    );
  }

  // Convert a BDisplay instance into JSON
  Map<String, dynamic> toJson() {
    return {
      'displayId': displayId,
      'displayName': displayName,
      'createdDateAndTime': createdDateAndTime.toIso8601String(),
      'mediaFiles': mediaFiles.map((media) => media.toJson()).toList(),
      'status': status,
      'latitude': latitude,
      // Include latitude
      'longitude': longitude,
      // Include longitude
      'boardIds': boardIds, // Include boardIds as a list of strings
    };
  }
}
