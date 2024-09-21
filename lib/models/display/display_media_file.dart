import 'dart:io';
import '../common/media_file.dart';
import '../common/media_type.dart';

class DisplayMediaFile extends MediaFile {
  final String displayId;

  DisplayMediaFile({
    required File file,
    required this.displayId,
    required String filename,
    required MediaType mediaType,
  }) : super(file: file, filename: filename, mediaType: mediaType);

  // Factory method to create a DisplayMediaFile instance from JSON data
  factory DisplayMediaFile.fromJson(Map<String, dynamic> json) {
    return DisplayMediaFile(
      file: File(json['filePath']),
      displayId: json['displayId'],
      filename: json['filename'],
      mediaType: MediaTypeExtension.fromJson(json['mediaType']),
    );
  }

  // Convert a DisplayMediaFile instance into JSON
  @override
  Map<String, dynamic> toJson() {
    final mediaFileJson = super.toJson(); // Call to the parent class method
    mediaFileJson['displayId'] = displayId; // Add specific property of DisplayMediaFile
    return mediaFileJson;
  }
}
