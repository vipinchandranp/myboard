import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/board/board.dart';
import '../models/display/bdisplay.dart';
import '../models/display/display_geotag_request.dart';
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
  Future<List<BDisplay>?> getDisplays({int page = 0, int size = 20}) async {
    try {
      final response = await client.get(
        Uri.parse('$apiUrl/display/list?page=$page&size=$size'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print(
            'Response body: ${response.body}'); // Debugging: print raw response
        final Map<String, dynamic> responseBody = json.decode(response.body);

        final List<dynamic> responseBodyList = responseBody['data'];

        final List<BDisplay> displays = responseBodyList
            .map((displayJson) => BDisplay.fromJson(displayJson))
            .toList();

        return displays;
      } else {
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

  Future<bool> geoTagDisplay(DisplayGeoTagRequest geoTagRequest) async {
    try {
      final response = await client.put(
        Uri.parse('$apiUrl/display/geo-tag'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'displayId': geoTagRequest.displayId,
          'latitude': geoTagRequest.latitude,
          'longitude': geoTagRequest.longitude,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Successful geo-tagging
      } else {
        handleError(response);
        return false;
      }
    } catch (e) {
      print('Error geo-tagging display: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> getTimeSlots(
      String displayId, DateTime date) async {
    try {
      String formattedDate =
          '${date.toLocal().year}-${date.toLocal().month.toString().padLeft(2, '0')}-${date.toLocal().day.toString().padLeft(2, '0')}';

      final response = await client.get(
        Uri.parse(
            '$apiUrl/display/get/time-slots?displayId=$displayId&date=$formattedDate'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');

        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic> timeSlotsList = responseBody['data']['timeSlots'];

        // Ensure the timeSlotsList is indeed a list
        if (timeSlotsList is List) {
          // Convert the list of dynamic to a list of Map<String, dynamic>
          return timeSlotsList.map((slot) {
            return {
              'id': slot['id'] ?? 'N/A',
              'active': slot['active'] ?? false,
              'createdAt': slot['createdAt']?.toString() ?? 'N/A',
              'lastModifiedAt': slot['lastModifiedAt']?.toString() ?? 'N/A',
              'createdBy': slot['createdBy'] ?? 'N/A',
              'modifiedBy': slot['modifiedBy'] ?? 'N/A',
              'display': slot['display'] ?? 'N/A',
              'board': slot['board'] ?? 'N/A',
              'startTime': _formatStartTime(slot['startTime']),
              'endTime': _formatEndTime(slot['endTime']),
              'status': slot['status'] ?? 'UNKNOWN',
            };
          }).toList();
        } else {
          print('Error: timeSlotsList is not a list');
          return [];
        }
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching time slots: $e');
      return null;
    }
  }

// Helper method to format start time
  String _formatStartTime(List<dynamic> startTime) {
    List<int> formattedStartTime =
        startTime.cast<int>(); // Cast the dynamic list to List<int>
    return '${formattedStartTime[0]}-${formattedStartTime[1].toString().padLeft(2, '0')}-${formattedStartTime[2].toString().padLeft(2, '0')} ${formattedStartTime[3].toString().padLeft(2, '0')}:${formattedStartTime[4].toString().padLeft(2, '0')}';
  }

// Helper method to format end time
  String _formatEndTime(List<dynamic> endTime) {
    List<int> formattedEndTime =
        endTime.cast<int>(); // Cast the dynamic list to List<int>
    return '${formattedEndTime[0]}-${formattedEndTime[1].toString().padLeft(2, '0')}-${formattedEndTime[2].toString().padLeft(2, '0')} ${formattedEndTime[3].toString().padLeft(2, '0')}:${formattedEndTime[4].toString().padLeft(2, '0')}';
  }

  Future<bool> saveBoardsWithTimeSlots(
    String displayId,
    List<Board> selectedBoardIds, // List of Board objects
    DateTime dateTime, // Use DateTime instead of String
    List<Map<String, String>> timeSlots,
  ) async {
    try {
      // Extract board IDs from the list of Board objects
      List<String> boardIds =
          selectedBoardIds.map((board) => board.boardId).toList();

      // Format the DateTime to ISO 8601 format for LocalDateTime in Java
      String formattedDateTime =
          dateTime.toIso8601String(); // '2024-10-02T14:30:00'

      // Prepare the request body
      Map<String, dynamic> requestBody = {
        'displayId': displayId,
        'boardIds': boardIds, // Use board IDs instead of Board objects
        'date': formattedDateTime, // Send the ISO 8601 formatted DateTime
        'timeslots': timeSlots,
      };

      final response = await client.put(
        Uri.parse('$apiUrl/display/update/time-slots'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('${requestBody}');

      if (response.statusCode == 200) {
        return true; // Successfully saved
      } else {
        handleError(response); // Handle the error
        return false; // Failed to save
      }
    } catch (e) {
      print('Error saving boards with time slots in repository: $e');
      return false;
    }
  }

  Future<List<String>?> getBoardIdsByDisplayId(String displayId) async {
    try {
      final response = await client.get(
        Uri.parse('$apiUrl/display/boards/$displayId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<String> boardIds = List<String>.from(responseBody['data']['boardIds']);
        return boardIds;
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching board IDs for display: $e');
      return null;
    }
  }
}
