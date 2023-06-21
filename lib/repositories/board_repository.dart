import 'dart:convert';

import 'package:myboard/config/api_config.dart';
import 'package:myboard/models/board.dart';
import 'package:http/http.dart' as http;

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
      if (response.statusCode == 200) {
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
}
