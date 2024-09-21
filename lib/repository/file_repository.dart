import 'dart:io';
import 'dart:typed_data'; // To handle binary data
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart'; // To save files locally
import 'base_repository.dart';
import 'dart:convert';

class FileService extends BaseRepository {
  FileService(BuildContext context) : super(context);

  // Fetch file from /file/board/{filename} endpoint
  Future<File?> fetchBoardFile(String filename) async {
    final url = Uri.parse('$apiUrl/file/board/$filename');
    return _downloadFile(url, filename);
  }

  // Fetch file from /file/display/{filename} endpoint
  Future<File?> fetchDisplayFile(String filename) async {
    final url = Uri.parse('$apiUrl/file/display/$filename');
    return _downloadFile(url, filename);
  }

  // Helper method to download and store files locally
  Future<File?> _downloadFile(Uri url, String filename) async {
    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        // Get the temp directory on the device
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/$filename';
        final file = File(filePath);

        // Write file bytes to disk
        await file.writeAsBytes(response.bodyBytes);

        print("File downloaded to: $filePath");
        return file;
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print("Error downloading file: $e");
      return null;
    }
  }

  // Helper function to convert response to JSON and extract necessary info
  Map<String, dynamic> extractDataFromResponseBody(http.Response response) {
    return json.decode(response.body) as Map<String, dynamic>;
  }
}
