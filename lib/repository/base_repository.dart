import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googleapis/docs/v1.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import '../config/api_config.dart';
import '../security/httpinterceptor.dart';

/// A base class for repositories, providing common functionality for API interactions.
abstract class BaseRepository {
  final String apiUrl = APIConfig.getRootURL();

  // Common HTTP client with interceptors
  final http.Client client;

  /// Creates an instance of [BaseRepository] with the provided [context] for SnackBar notifications.
  BaseRepository(BuildContext context)
      : client = InterceptedClient.build(
    interceptors: [
      HttpInterceptor(
        showSnackBar: (String type, String message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: _getSnackBarColor(type),
            ),
          );
        },
      ),
    ],
    client: http.Client(),
  );

  /// Handles errors by printing them and throwing an exception.
  void handleError(http.Response response) {
    print('Error: ${response.statusCode} ${response.body}');
    throw Exception('Request failed with status: ${response.statusCode}');
  }

  /// Returns a color for the SnackBar based on the message type.
  static MaterialColor _getSnackBarColor(String messageType) {
    switch (messageType) {
      case 'INFO':
        return Colors.blue;
      case 'WARNING':
        return Colors.orange;
      case 'ERROR':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Extracts the `data` field from the JSON response body.
  dynamic extractDataFromResponseBody(http.Response response) {
    try {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse['data'];
    } catch (e) {
      print('Error extracting data from response body: $e');
      return null;
    }
  }
}
