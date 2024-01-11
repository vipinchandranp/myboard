import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myboard/config/api_config.dart';
import 'package:myboard/models/board-id-title.dart';
import 'package:myboard/models/board.dart';
import 'package:http/http.dart' as http;
import 'package:myboard/models/user.dart';
import 'package:myboard/screens/pin_board_screen.dart';
import 'package:myboard/utils/token_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardRepository {
  final String _apiUrl = APIConfig.getRootURL();
  final GetIt getIt = GetIt.instance;

  Future<List<BoardIdTitle>> getTitleAndId() async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
          getIt<TokenInterceptorHttpClient>();

      final response = await tokenInterceptor.get(
        Uri.parse('$_apiUrl/v1/board/title-id'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        final titleIdData =
            data.map((item) => BoardIdTitle.fromJson(item)).toList();
        return titleIdData;
      } else {
        // Handle error case
        throw Exception('Failed to fetch title and ID data');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to fetch title and ID data');
    }
  }

  Future<void> saveBoardItem(BuildContext context, Board board) async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
          getIt<TokenInterceptorHttpClient>();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_apiUrl/v1/board/save'),
      );

      request.fields['boardTitle'] = board.title!;
      request.fields['boardDesc'] = board.description!;

      if (board.imageFile != null) {
        try {
          XFile imageFile = await board.imageFile!;

          // Check if the app is running in a web environment
          if (kIsWeb) {
            // Use fromBytes for web environments
            List<int> imageBytes = await imageFile.readAsBytes();
            var imagePart = http.MultipartFile.fromBytes(
              'imageFile',
              imageBytes,
              filename: board.title!.replaceAll(' ', '_') + '.jpg',
              contentType: MediaType('application',
                  'octet-stream'), // Replace with the correct MIME type
            );

            request.files.add(imagePart);
          } else {
            // Use fromPath for non-web environments
            var imagePart = await http.MultipartFile.fromPath(
              'imageFile',
              imageFile.path,
              filename: board.title!.replaceAll(' ', '_') + '.jpg',
            );
            request.files.add(imagePart);
          }
        } catch (e) {
          print('Error creating MultipartFile: $e');
          // Handle the error appropriately
        }
      }

      var response = await tokenInterceptor.send(request);

      if (response.statusCode == 201) {
        print('Board item saved successfully');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PinBoardScreen()),
        );
      } else {
        throw Exception('Failed to save board item');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to save board item');
    } finally {
      // Any cleanup code can go here
    }
  }

  Future<List<Board>> getBoardItems() async {
    try {
      // Retrieve the TokenInterceptorHttpClient from get_it
      final TokenInterceptorHttpClient tokenInterceptor =
          getIt<TokenInterceptorHttpClient>();

      // Use the TokenInterceptorHttpClient to make the authorized request
      final response =
          await tokenInterceptor.get(Uri.parse('$_apiUrl/v1/board/items'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        final boards = data.map((item) => Board.fromJson(item)).toList();
        return boards;
      } else {
        // Handle error case
        throw Exception('Failed to fetch board items');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to fetch board items');
    }
  }

  Future<void> updateBoard(Board board) async {
    // Convert the updated board object to JSON
    final boardJson = jsonEncode(board);
    try {
      final response = await http.put(
        Uri.parse('$_apiUrl/v1/board/update/${board.id}'),
        body: boardJson,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Board item updated successfully
        print('Board item updated successfully');
      } else {
        // Failed to update board item
        print('Failed to update board item');
      }
    } catch (e) {
      // Handle any errors that occurred during the API call
      print('API error: $e');
    }
  }

  Future<Uint8List> getBoardImageById(String boardId) async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
          getIt<TokenInterceptorHttpClient>();

      final response = await tokenInterceptor.get(
        Uri.parse('$_apiUrl/v1/board/details/$boardId'),
      );

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];

        if (contentType != null && contentType.contains('image')) {
          // If the content type indicates an image, return the image bytes
          return response.bodyBytes;
        } else {
          // If the content type is not an image, handle it accordingly
          throw Exception('The response is not an image');
        }
      } else {
        throw Exception('Failed to fetch board details');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to fetch board details');
    }
  }
}
