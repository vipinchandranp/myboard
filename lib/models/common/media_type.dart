// Enum for media types (image or video)
enum MediaType {
  image,
  video,
}

// Extension on MediaType to handle JSON conversion
extension MediaTypeExtension on MediaType {
  // Converts a JSON string to a MediaType enum
  static MediaType fromJson(String mediaType) {
    switch (mediaType.toLowerCase()) {
      case 'image':
        return MediaType.image;
      case 'video':
        return MediaType.video;
      default:
        throw Exception('Unknown media type: $mediaType');
    }
  }

  // Converts a MediaType enum to a JSON string
  String toJson() {
    return this.toString().split('.').last;
  }
}
