import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/board/board.dart';
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

  // Fetches a list of boards with pagination
  Future<List<Board>?> getBoards({int page = 0, int size = 4}) async {
    try {
      final response = await client.get(
        Uri.parse('$apiUrl/board/list?page=$page&size=$size'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print('Response body: ${response.body}'); // Debugging: print raw response
        final Map<String, dynamic> responseBody = json.decode(response.body);

        final List<dynamic> responseBodyList = responseBody['data'];

        final List<Board> boards = responseBodyList
            .map((boardJson) => Board.fromJson(boardJson))
            .toList();

        return boards;
      }
      else {
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

}
