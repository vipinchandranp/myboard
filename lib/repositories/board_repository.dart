import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myboard/config/api_config.dart';
import 'package:myboard/models/board.dart';
import 'package:http/http.dart' as http;
import 'package:myboard/models/user.dart';
import 'package:myboard/screens/pin_board_screen.dart';
import 'package:myboard/utils/token_interceptor.dart';
import 'package:get_it/get_it.dart';

class BoardRepository {
  final String _apiUrl = APIConfig.getRootURL();
  final GetIt getIt = GetIt.instance;

  Future<void> saveBoardItem(BuildContext context, Board board) async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
          getIt<TokenInterceptorHttpClient>();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_apiUrl/v1/board/save'),
      );

      request.fields['board'] = jsonEncode(board.toJson());

      if (board.imageFile != null) {
        List<int> imageBytes = await board.imageFile!.readAsBytes();
        String fileName = board.title!.replaceAll(' ', '_') + '.jpg';

        var imagePart = http.MultipartFile.fromBytes(
          'imageFile',
          imageBytes,
          filename: fileName,
        );
        request.files.add(imagePart);
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
}
