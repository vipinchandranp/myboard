import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:myboard/config/api_config.dart';
import 'package:myboard/models/board-id-title.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/models/board_with_image.dart';
import 'package:myboard/common-util/common_util_token_interceptor.dart';

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

      // Add board details as fields
      request.fields['boardTitle'] = board.title!;

      // Add image file if available
      await addImageFileToRequest(request, board.imageFile);

      // Add display details
      if (board.displayDetails != null && board.displayDetails!.isNotEmpty) {
        for (var displayDetails in board.displayDetails!) {
          // Use the actual display details name here
          request.fields['displayDetails'] =
              jsonEncode(displayDetails.toJson());
        }
      }

      var response = await tokenInterceptor.send(request);

      if (response.statusCode == 201) {
        print('Board item saved successfully');
      } else {
        throw Exception(
            'Failed to save board item. Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to save board item');
    } finally {
      // Any cleanup code can go here
    }
  }

  Future<void> addImageFileToRequest(
      http.MultipartRequest request, XFile? imageFile) async {
    if (imageFile != null) {
      try {
        // Check if the app is running in a web environment
        if (kIsWeb) {
          // Use fromBytes for web environments
          List<int> imageBytes = await imageFile.readAsBytes();
          var imagePart = http.MultipartFile.fromBytes(
            'imageFile',
            imageBytes,
            filename: imageFile.path.replaceAll(' ', '_') + '.jpg',
          );

          request.files.add(imagePart);
        } else {
          // Use fromPath for non-web environments
          var imagePart = await http.MultipartFile.fromPath(
            'imageFile',
            imageFile.path,
            filename: imageFile.path.replaceAll(' ', '_') + '.jpg',
          );
          request.files.add(imagePart);
        }
      } catch (e) {
        print('Error adding image file to request: $e');
        // Handle the error appropriately
        throw Exception('Failed to add image file to the request');
      }
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

  Future<List<BoardWithImage>> getBoardItems({
    int page = 1,
    int size = 10,
  }) async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
          getIt<TokenInterceptorHttpClient>();

      final response = await tokenInterceptor.get(
        Uri.parse('$_apiUrl/v1/board/items?page=$page&size=$size'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        final boardsWithImage = <BoardWithImage>[];

        for (var item in data) {
          final board = Board.fromJson(item['board']);
          final imageBytesString = item['imageBytes'] as String;

          // Convert base64-encoded string to Uint8List
          final imageBytes = base64.decode(imageBytesString);

          boardsWithImage
              .add(BoardWithImage(board: board, imageBytes: imageBytes));
        }

        return boardsWithImage;
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

  Future<List<BoardWithImage>> getPaginatedBoardItems(
      int page, int size) async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
          getIt<TokenInterceptorHttpClient>();

      final response = await tokenInterceptor.get(
        Uri.parse('$_apiUrl/v1/board/items?page=$page&size=$size'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        final boardsWithImage = <BoardWithImage>[];

        for (var item in data) {
          final board = Board.fromJson(item['board']);
          final imageBytesString = item['imageBytes'] as String;

          // Convert base64-encoded string to Uint8List
          final imageBytes = base64.decode(imageBytesString);

          boardsWithImage
              .add(BoardWithImage(board: board, imageBytes: imageBytes));
        }

        return boardsWithImage;
      } else {
        // Handle error case
        throw Exception('Failed to fetch paginated board items');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to fetch paginated board items');
    }
  }
}
