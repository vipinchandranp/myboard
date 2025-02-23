import '../common/media_file.dart';

class BDisplay {
  final String displayId;
  final String displayName;
  final DateTime createdDateAndTime;
  List<MediaFile> mediaFiles;
  final String status;
  List<String> boardIds; // Changed to List<String>
  final double? latitude;
  final double? longitude;
  final String displayPin; // Added the displayPin field
  final double? price;

  // Transient properties for tracking user's reaction
  bool likedByCurrentUser;
  bool dislikedByCurrentUser;

  // Fields for the number of likes and dislikes
  int numberOfLikes;
  int numberOfDislikes;

  BDisplay({
    required this.displayId,
    required this.displayName,
    required this.createdDateAndTime,
    this.mediaFiles = const [], // Provide a default empty list
    required this.status,
    this.latitude, // Optional latitude
    this.longitude, // Optional longitude
    this.boardIds = const [], // Provide a default empty list for boardIds
    required this.displayPin, // Ensure the displayPin is passed into the constructor
    this.price,
    this.likedByCurrentUser = false,
    this.dislikedByCurrentUser = false,
    this.numberOfLikes = 0,
    this.numberOfDislikes = 0,
  });

  // Factory method to create a BDisplay instance from JSON data.
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
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      boardIds: (json['boardIds'] as List?)?.map((id) => id.toString()).toList() ?? [],
      displayPin: json['displayPin'] ?? '',
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      likedByCurrentUser: json['likedByCurrentUser'] ?? false,
      dislikedByCurrentUser: json['dislikedByCurrentUser'] ?? false,
      numberOfLikes: json['numberOfLikes'] ?? 0,
      numberOfDislikes: json['numberOfDislikes'] ?? 0,
    );
  }

  // Convert a BDisplay instance into JSON.
  Map<String, dynamic> toJson() {
    return {
      'displayId': displayId,
      'displayName': displayName,
      'createdDateAndTime': createdDateAndTime.toIso8601String(),
      'mediaFiles': mediaFiles.map((media) => media.toJson()).toList(),
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'boardIds': boardIds,
      'displayPin': displayPin,
      'price': price,
      'likedByCurrentUser': likedByCurrentUser,
      'dislikedByCurrentUser': dislikedByCurrentUser,
      'numberOfLikes': numberOfLikes,
      'numberOfDislikes': numberOfDislikes,
    };
  }
}
