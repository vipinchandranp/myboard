import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myboard/screens/common/filter/filter_data.dart';
import '../models/board/board.dart';
import '../models/common/comment.dart';
import 'base_repository.dart';

class BoardService extends BaseRepository {
  BoardService(BuildContext context) : super(context);

  // Saves a new board with the given media file and board name

  // Saves a new board with the given media file and board name
  Future<Map?> saveBoard(File file, String boardName) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$apiUrl/board/media/save'),
      )
        ..fields['boardName'] = boardName
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      // Send the request and get the streamed response
      final streamedResponse = await client.send(request);

      // Convert the streamed response to a regular response
      final response = await http.Response.fromStream(streamedResponse);
      Map data = extractDataFromResponseBody(response);
      // Print response details
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${data['boardId']}');
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
      print('Error saving board: $e');
      return null;
    }
  }

  // Adds media to an existing board
  Future<String?> addBoardMedia(String boardId, File file) async {
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$apiUrl/board/media/add'),
      )
        ..fields['boardId'] = boardId
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
      print('Error adding board media: $e');
      return null;
    }
  }

  // Deletes a media file from a board
  Future<bool> deleteBoardFile(String boardId, String mediaName) async {
    try {
      final response = await client.delete(
        Uri.parse('$apiUrl/board/media/delete/$boardId/$mediaName'),
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
  Future<bool> deleteBoard(String boardId) async {
    try {
      final response = await client.delete(
        Uri.parse('$apiUrl/board/delete/$boardId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        handleError(response);
        return false;
      }
    } catch (e) {
      print('Error deleting board: $e');
      return false;
    }
  }

  Future<List<Board>?> getBoards(FilterData? filter) async {
    try {
      // Use toQueryParams method if filter is not null; otherwise, use an empty map
      final Map<String, dynamic> queryParams = filter?.toQueryParams() ?? {};

      // Create query string from query parameters
      final queryString = Uri(queryParameters: queryParams).query;

      // Construct the complete URL with the query string
      // Only append '?' if queryString is not empty
      final url = queryString.isNotEmpty
          ? Uri.parse('$apiUrl/board/list?$queryString')
          : Uri.parse('$apiUrl/board/list');

      final response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final Map<String, dynamic> responseBody = json.decode(response.body);

        final List<dynamic> responseBodyList = responseBody['data'];
        final List<Board> boards = responseBodyList
            .map((boardJson) => Board.fromJson(boardJson))
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


  // Fetches details of a specific board
  Future<Board?> getBoardById(String boardId) async {
    try {
      final response = await client.get(
        Uri.parse('$apiUrl/board/$boardId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        return Board.fromJson(data);
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching board by ID: $e');
      return null;
    }
  }

  // Adds a rating to a board
  Future<String?> addRating(String boardId, double ratingValue) async {
    try {
      final request = http.Request(
        'POST',
        Uri.parse('$apiUrl/board/$boardId/rating?rating=$ratingValue'), // Updated URL to use displayId
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



  // Method to get the rating of a board by its ID
  Future<double?> getBoardRating(String boardId) async {
    try {
      // Send GET request to fetch rating for the board with given boardId
      final response = await client.get(
        Uri.parse('$apiUrl/board/$boardId/rating'),
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
      print('Error fetching board rating: $e');
      return null;
    }
  }

  // Adds a comment to a board
  Future<String?> addComment(String boardId, String commentText) async {
    try {
      final response = await client.post(
        Uri.parse('$apiUrl/board/$boardId/comment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'commentText': commentText}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['message'];
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error adding comment: $e');
      return null;
    }
  }

  Future<List<Comment>?> getComments(String boardId) async {
    try {
      final response = await client.get(
        Uri.parse('$apiUrl/board/$boardId/comments'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body)['data'];
        return responseBody.map((commentJson) => Comment.fromJson(commentJson)).toList();
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
  Future<bool> likeBoard(String boardId) async {
    try {
      final response = await client.post(
        Uri.parse('$apiUrl/board/like/$boardId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        handleError(response);
        return false;
      }
    } catch (e) {
      print('Error liking board: $e');
      return false;
    }
  }

  // Method to add a dislike to a display
  Future<bool> dislikeBoard(String boardId) async {
    try {
      final response = await client.post(
        Uri.parse('$apiUrl/board/dislike/$boardId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        handleError(response);
        return false;
      }
    } catch (e) {
      print('Error disliking board: $e');
      return false;
    }
  }

  // Undoes like for a display
  Future<bool> undoLikeBoard(String boardId) async {
    try {
      final response = await client.post(
        Uri.parse('$apiUrl/board/undo-like/$boardId'),
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
  Future<bool> undoDislikeBoard(String boardId) async {
    try {
      final response = await client.post(
        Uri.parse('$apiUrl/board/undo-dislike/$boardId'),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        handleError(response);
        return false;
      }
    } catch (e) {
      print('Error undoing dislike for display: $e');
      return false;
    }
  }


}
