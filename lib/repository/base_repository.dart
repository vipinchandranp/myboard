import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'; // Import the package
import '../config/api_config.dart';
import '../security/httpinterceptor.dart';

abstract class BaseRepository {
  final String apiUrl = APIConfig.getRootURL();
  final http.Client client;
  final BuildContext context; // Store the context

  /// Creates an instance of [BaseRepository] with the provided [context].
  BaseRepository(this.context)
      : client = InterceptedClient.build(
    interceptors: [
      HttpInterceptor(
        showSnackBar: (String type, String message) {
          _showAwesomeSnackBar(context, type, message);
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

  /// Extracts and displays messages from the JSON response body.
  void handleResponseMessages(http.Response response) {
    try {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final messages = jsonResponse['messages'];

      if (messages != null) {
        messages.forEach((type, messageList) {
          if (messageList is List && messageList.isNotEmpty) {
            for (var message in messageList) {
              _showAwesomeSnackBar(context, type, message);
            }
          }
        });
      }
    } catch (e) {
      print('Error handling response messages: $e');
    }
  }

  /// Extracts the `data` field from the JSON response body.
  dynamic extractDataFromResponseBody(http.Response response) {
    try {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      handleResponseMessages(response);
      return jsonResponse['data'];
    } catch (e) {
      print('Error extracting data from response body: $e');
      return null;
    }
  }

  /// Returns a color for the SnackBar based on the message type.
  static ContentType _getContentType(String messageType) {
    switch (messageType) {
      case 'INFO':
        return ContentType.help;
      case 'WARNING':
        return ContentType.warning;
      case 'ERROR':
        return ContentType.failure;
      default:
        return ContentType.success;
    }
  }

  /// Shows a custom AwesomeSnackbarContent.
  static void _showAwesomeSnackBar(
      BuildContext context, String type, String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: type, // Title of the message type
        message: message, // Message content
        contentType: _getContentType(type),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
