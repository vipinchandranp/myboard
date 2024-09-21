import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/display/bdisplay.dart';
import 'base_repository.dart';

class DisplayService extends BaseRepository {
  DisplayService(BuildContext context) : super(context);

  // Saves a new display with the given media file and display name

  // Saves a new display with the given media file and display name
  Future<Map?> saveDisplay(File file, String displayName) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$apiUrl/display/media/save'),
      )
        ..fields['displayName'] = displayName
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      // Send the request and get the streamed response
      final streamedResponse = await client.send(request);

      // Convert the streamed response to a regular response
      final response = await http.Response.fromStream(streamedResponse);
      Map data = extractDataFromResponseBody(response);
      // Print response details
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${data['displayId']}');
      print('Response Body: ${data['fileName']}');
      print('Response Headers: ${response.headers}');

      if (response.statusCode == 200) {
        // Assuming the response body contains the boardId directly
        return data;
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error saving display: $e');
      return null;
    }
  }

  // Adds media to an existing display
  Future<String?> addDisplayMedia(String displayId, File file) async {
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$apiUrl/display/media/add'),
      )
        ..fields['displayId'] = displayId
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error adding display media: $e');
      return null;
    }
  }

  // Deletes a media file from a board
  Future<bool> deleteDisplayFile(String displayId, String mediaName) async {
    try {
      final response = await client.delete(
        Uri.parse('$apiUrl/display/media/delete/$displayId/$mediaName'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        handleError(response);
        return false;
      }
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  // Deletes a board
  Future<bool> deleteDisplay(String displayId) async {
    try {
      final response = await client.delete(
        Uri.parse('$apiUrl/display/delete/$displayId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        handleError(response);
        return false;
      }
    } catch (e) {
      print('Error deleting display: $e');
      return false;
    }
  }

  // Fetches a list of displays with pagination
  Future<List<BDisplay>?> getDisplays({int page = 0, int size = 4}) async {
    try {
      final response = await client.get(
        Uri.parse('$apiUrl/display/list?page=$page&size=$size'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print('Response body: ${response.body}'); // Debugging: print raw response
        final Map<String, dynamic> responseBody = json.decode(response.body);

        final List<dynamic> responseBodyList = responseBody['data'];

        final List<BDisplay> displays = responseBodyList
            .map((displayJson) => BDisplay.fromJson(displayJson))
            .toList();

        return displays;
      }
      else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching displays: $e');
      return null;
    }
  }


  // Fetches details of a specific display
  Future<BDisplay?> getDisplayById(String displayId) async {
    try {
      final response = await client.get(
        Uri.parse('$apiUrl/display/$displayId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        return BDisplay.fromJson(data);
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching display by ID: $e');
      return null;
    }
  }

}
