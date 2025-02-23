import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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

  // Synchronous factory (if filePath is a local path)
  factory MediaFile.fromJson(Map<String, dynamic> json) {
    return MediaFile(
      file: File(json['filePath'] ?? ''),
      filename: json['fileName'] ?? 'unknown',
      mediaType: MediaTypeExtension.fromJson(json['mediaType']),
    );
  }

  // Asynchronous factory method to handle remote URLs.
  // If the filePath starts with "http", it downloads the file and returns a MediaFile.
  static Future<MediaFile> fromJsonAsync(Map<String, dynamic> json) async {
    String filePath = json['filePath'] ?? '';
    File file;
    if (filePath.startsWith("http")) {
      try {
        // Download the file
        final response = await http.get(Uri.parse(filePath));
        if (response.statusCode == 200) {
          // Get a temporary directory
          final tempDir = await getTemporaryDirectory();
          final fileName = filePath.split('/').last;
          final tempFile = File('${tempDir.path}/$fileName');
          await tempFile.writeAsBytes(response.bodyBytes);
          file = tempFile;
        } else {
          // If download fails, fallback to an empty File
          file = File('');
        }
      } catch (e) {
        // On error, fallback
        file = File('');
      }
    } else {
      file = File(filePath);
    }
    return MediaFile(
      file: file,
      filename: json['fileName'] ?? 'unknown',
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
