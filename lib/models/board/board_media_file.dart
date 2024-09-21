import 'dart:io';

import '../common/media_file.dart';
import '../common/media_type.dart';
class BoardMediaFile extends MediaFile {
  final String boardId;

  BoardMediaFile({
    required File file,
    required this.boardId,
    required String filename,
    required MediaType mediaType,
  }) : super(file: file, filename: filename, mediaType: mediaType);

  // Factory method to create a DisplayMediaFile instance from JSON data
  factory BoardMediaFile.fromJson(Map<String, dynamic> json) {
    return BoardMediaFile(
      file: File(json['filePath']),
      boardId: json['boardId'],
      filename: json['filename'],
      mediaType: MediaTypeExtension.fromJson(json['mediaType']),
    );
  }

  // Convert a DisplayMediaFile instance into JSON
  @override
  Map<String, dynamic> toJson() {
    final mediaFileJson = super.toJson(); // Call to the parent class method
    mediaFileJson['boardId'] = boardId; // Add specific property of DisplayMediaFile
    return mediaFileJson;
  }
}