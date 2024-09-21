import 'dart:io';

import 'media_type.dart';

class MediaFile {
  final File file;
  final String filename;
  final MediaType mediaType;

  MediaFile({
    required this.file,
    required this.filename,
    required this.mediaType,
  });

  // Factory method to create a MediaFile instance from JSON data
  factory MediaFile.fromJson(Map<String, dynamic> json) {
    return MediaFile(
      file: File(json['filePath'] ?? ''), // Handle null for file path
      filename: json['fileName'] ?? 'unknown', // Provide a default value if filename is null
      mediaType: MediaTypeExtension.fromJson(json['mediaType']),
    );
  }

  // Convert a MediaFile instance into JSON
  Map<String, dynamic> toJson() {
    return {
      'filePath': file.path,
      'filename': filename,
      'mediaType': mediaType.toString().split('.').last, // Store enum as a string
    };
  }
}
