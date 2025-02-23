import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_models/display_save.dart';
import '../models/common/comment.dart';
import '../models/display/bdisplay.dart';
import '../models/display/currently_playing_boards_response.dart';
import '../models/display/display_geotag_request.dart';
import '../screens/common/filter/filter_data.dart';
import 'base_repository.dart';

class DisplayService extends BaseRepository {
  DisplayService(BuildContext context) : super(context);
// Saves a new display with the given media file and display name
  Future<String?> saveDisplay(SaveDisplay saveDisplay) async {
    try {
      // Print field values before sending the request
      print('Display Name: ${saveDisplay.displayName}');
      print('Price: ${saveDisplay.price}');
      print('Latitude: ${saveDisplay.latitude}');
      print('Longitude: ${saveDisplay.longitude}');
      print('Number of Files: ${saveDisplay.files.length}');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$apiUrl/display/save'),
      )
        ..fields['displayName'] = saveDisplay.displayName
        ..fields['price'] = saveDisplay.price.toString()
        ..fields['latitude'] = saveDisplay.latitude?.toString() ?? ''
        ..fields['longitude'] = saveDisplay.longitude?.toString() ?? '';

      // Add multiple files
      for (var file in saveDisplay.files) {
        request.files.add(
            await http.MultipartFile.fromPath('files', file.path));
      }

      // Send the request using the inherited client
      final streamedResponse = await client.send(request);

      // Convert the streamed response to a regular response using http.Response.fromStream
      final response = await http.Response.fromStream(streamedResponse);
      String data = extractDataFromResponseBody(response);

      if (response.statusCode == 200) {
        // Assuming the response body contains the displayId directly
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

  Future<List<BDisplay>?> getDisplays(FilterData? filter) async {
    try {
      // Use toQueryParams method if filter is not null; otherwise, use an empty map
      final Map<String, dynamic> queryParams = filter?.toQueryParams() ?? {};

      // Create query string from query parameters
      final queryString = Uri(queryParameters: queryParams).query;

      // Construct the complete URL with the query string
      // Only append '?' if queryString is not empty
      final url = queryString.isNotEmpty
          ? Uri.parse('$apiUrl/display/list?$queryString')
          : Uri.parse('$apiUrl/display/list');

      final response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final Map<String, dynamic> responseBody = json.decode(response.body);

        final List<dynamic> responseBodyList = responseBody['data'];
        final List<BDisplay> boards = responseBodyList
            .map((boardJson) => BDisplay.fromJson(boardJson))
            .toList();

        return boards;
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching boards: $e');
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

  Future<bool> saveBoardsWithTimeSlots({
    required String displayId,
    required List<String> boardIds,
    required DateTime date,
    required List<Map<String, String>> timeSlots,
    required String transactionId, // Add transactionId parameter
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/displays/$displayId/save'),
        body: jsonEncode({
          'boardIds': boardIds,
          'date': date.toIso8601String(),
          'timeSlots': timeSlots,
          'transactionId': transactionId, // Include transactionId in the request
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to save data: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in saveBoardsWithTimeSlots: $e');
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
        final List<String> boardIds = List<String>.from(responseBody['data']);
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

  // Method to fetch nearby displays
  Future<List<BDisplay>?> getNearbyDisplays() async {
    try {
      final response = await client.get(
        Uri.parse('$apiUrl/display/nearby'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        final List<dynamic> responseBodyList = responseBody['data'];

        // Map the response to a list of BDisplay objects
        final List<BDisplay> nearbyDisplays = responseBodyList
            .map((displayJson) => BDisplay.fromJson(displayJson))
            .toList();

        return nearbyDisplays;
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching nearby displays: $e');
      return null;
    }
  }

  Future<List<BDisplay>?> getAllDisplays() async {
    try {
      final response = await client.get(
        Uri.parse('$apiUrl/display/all'),
        // Assuming this endpoint returns all displays
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
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
      print('Error fetching all displays: $e');
      return null;
    }
  }

  // Method to fetch currently playing boards by display ID
  Future<CurrentlyPlayingBoardsResponse?> getCurrentlyPlayingBoards(
      String displayId) async {
    try {
      final response = await client.get(
        Uri.parse('$apiUrl/display/boards/status/$displayId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        return parseCurrentlyPlayingBoardsResponse(response.body);
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching currently playing boards: $e');
      return null;
    }
  }

  Future<String?> addRating(String displayId, double ratingValue) async {
    try {
      final request = http.Request(
        'POST',
        Uri.parse('$apiUrl/display/$displayId/rating?rating=$ratingValue'), // Updated URL to use displayId
      )
        ..headers['Content-Type'] = 'application/json';

      final response = await client.send(request);

      if (response.statusCode == 200) {
        return 'Rating added successfully';
      } else {
        return null;
      }
    } catch (e) {
      print('Error adding rating: $e');
      return null;
    }
  }

  // Method to get the rating of a display by its ID
  Future<double?> getDisplayRating(String displayId) async {
    try {
      // Send GET request to fetch rating for the display with given displayId
      final response = await client.get(
        Uri.parse('$apiUrl/display/$displayId/rating'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Assuming the response contains the rating directly as a double
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final double rating = responseBody['data'];
        return rating;
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching display rating: $e');
      return null;
    }
  }



  Future<String?> addComment(String displayId, String commentText) async {
    try {
      final response = await client.post(
        Uri.parse('$apiUrl/display/$displayId/comment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'commentText': commentText,
          // Send the commentText in the request body
        }),
      );

      if (response.statusCode == 200) {
        // Assuming the response contains a success message or data
        return 'Comment added successfully';
      } else {
        handleError(response); // Handle the error if the response is not 200
        return null;
      }
    } catch (e) {
      print('Error adding comment: $e');
      return null;
    }
  }

  Future<List<Comment>?> getComments(String displayId) async {
    try {
      final response = await client.get(
        Uri.parse('$apiUrl/display/$displayId/comments'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body)['data'];
        return responseBody
            .map((commentJson) => Comment.fromJson(commentJson))
            .toList();
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching comments for display: $e');
      return null;
    }
  }

  // Method to add a like to a display
  Future<bool> likeDisplay(String displayId) async {
    try {
      final response = await client.post(
        Uri.parse('$apiUrl/display/like/$displayId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        handleError(response);
        return false;
      }
    } catch (e) {
      print('Error liking display: $e');
      return false;
    }
  }

  // Method to add a dislike to a display
  Future<bool> dislikeDisplay(String displayId) async {
    try {
      final response = await client.post(
        Uri.parse('$apiUrl/display/dislike/$displayId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        handleError(response);
        return false;
      }
    } catch (e) {
      print('Error disliking display: $e');
      return false;
    }
  }

// Undoes like for a display
  Future<bool> undoLikeDisplay(String displayId) async {
    try {
      final response = await client.post(
        Uri.parse('$apiUrl/display/undo-like/$displayId'),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        handleError(response);
        return false;
      }
    } catch (e) {
      print('Error undoing like for display: $e');
      return false;
    }
  }

  // Undoes dislike for a display
  Future<bool> undoDislikeDisplay(String displayId) async {
    try {
      final response = await client.post(
        Uri.parse('$apiUrl/display/undo-dislike/$displayId'),
      );

      return false;
    } catch (e) {
      print('Error undoing dislike for display: $e');
      return false;
    }
  }

  Future<int?> getNumberOfLikes(String displayId) async {
    try {
      final response = await client.get(
        Uri.parse('$apiUrl/display/$displayId/likes'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        // Assuming the display details include a 'likes' field in the 'data' section
        final int likes = responseBody['data']?? 0;
        return likes;
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching number of likes: $e');
      return null;
    }
  }

  Future<int?> getNumberOfDisLikes(String displayId) async {
    try {
      final response = await client.get(
        Uri.parse('$apiUrl/display/$displayId/dislikes'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        // Assuming the display details include a 'likes' field in the 'data' section
        final int likes = responseBody['data']?? 0;
        return likes;
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching number of likes: $e');
      return null;
    }
  }


}
