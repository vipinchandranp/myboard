import '../common/media_file.dart';
import 'display_media_file.dart';

class BDisplay {
  final String displayId;
  final String displayName;
  final DateTime createdDateAndTime;
  List<MediaFile> mediaFiles;
  final String status;

  // New properties for geo-location
  final double? latitude;
  final double? longitude;

  BDisplay({
    required this.displayId,
    required this.displayName,
    required this.createdDateAndTime,
    this.mediaFiles = const [], // Provide a default empty list
    required this.status,
    this.latitude,  // Optional latitude
    this.longitude, // Optional longitude
  });

  // Factory method to create a BDisplay instance from JSON data
  factory BDisplay.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(json['createdDateAndTime']?.toString() ?? '');
    } catch (e) {
      parsedDate = DateTime.now();
    }

    return BDisplay(
      displayId: json['displayId'] ?? 'unknown',
      displayName: json['displayName'] ?? 'Unnamed Display',
      createdDateAndTime: parsedDate,
      mediaFiles: (json['mediaFiles'] as List?)
          ?.map((mediaJson) => MediaFile.fromJson(mediaJson))
          .toList() ?? [],
      status: json['status'] ?? 'unknown',
      latitude: json['latitude'],  // Parse latitude
      longitude: json['longitude'], // Parse longitude
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
      'latitude': latitude,   // Include latitude
      'longitude': longitude, // Include longitude
    };
  }
}
