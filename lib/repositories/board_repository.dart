import 'dart:convert';

import 'package:myboard/config/api_config.dart';
import 'package:myboard/models/board.dart';
import 'package:http/http.dart' as http;
import 'package:myboard/models/user.dart';

class BoardRepository {
  final String _apiUrl = APIConfig.getRootURL();

  Future<void> saveBoardItem(Board board) async {
    try {
      final response = await http.post(Uri.parse('$_apiUrl/v1/board/save'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(<String, String>{
            'userId': board.userId,
            'title': board.title,
            'description': board.description,
          }));
      if (response.statusCode == 201) {
        // Board item saved successfully
        print('Board item saved successfully');
      } else {
        // Handle error case
        throw Exception('Failed to save board item');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to save board item');
    }
  }

  Future<List<Board>> getBoardItems(MyBoardUser? user) async {
    try {
      if (user == null) throw Exception('No Authenticated user found');
      final response =
          await http.get(Uri.parse('$_apiUrl/v1/board/items/${user.id}'));
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
    // Convert the displayDateTimeMap to JSON
    final updatedDisplayDateTimeMap = <String, DateTimeSlot>{};
    board.displayDetails.forEach((key, value) {
      updatedDisplayDateTimeMap[key] = value;
    });

    // Create the board object with the updated displayDateTimeMap
    final updatedBoard = board.copyWith(displayDetails: updatedDisplayDateTimeMap);

    // Convert the updated board object to JSON
    final boardJson = jsonEncode(updatedBoard.toJson());
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
