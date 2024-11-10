import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../api_models/main_response.dart';
import '../screens/notification/notification_broadcaster_model.dart';
import 'base_repository.dart';

class NotificationService extends BaseRepository {
  NotificationService(BuildContext context) : super(context);

  // Marks a notification as read by sending a PUT request to the backend.
  Future<MainResponse<String>> markNotificationAsRead(
      String notificationId) async {
    try {
      final response = await client.put(
        Uri.parse('$apiUrl/notification/mark-as-read/$notificationId'),
      );

      if (response.statusCode == 200) {
        return MainResponse<String>.fromJson(
          jsonDecode(response.body),
          (data) => data as String, // Convert the JSON 'data' field to String
        );
      } else {
        _handleError(response);
        throw Exception(
            'Failed to mark notification as read: ${response.body}');
      }
    } catch (e) {
      print('Error marking notification as read: $e');
      throw e; // Rethrow the error to handle it in the calling code
    }
  }

// Method to fetch all notifications with pagination and handle null checks
  Future<MainResponse<List<NotificationBroadcasterModel>>> fetchAllNotifications(int page, int size) async {
    try {
      final response = await client.get(
        Uri.parse('$apiUrl/notification/all?page=$page&size=$size'),
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);

        // Check if data and content fields are present
        if (decodedJson == null || !decodedJson.containsKey('data')) {
          throw Exception('Unexpected response format: Missing "data" field');
        }

        final mainResponse = MainResponse<List<NotificationBroadcasterModel>>.fromJson(
          decodedJson,
              (data) {
            final List<dynamic> notificationsList = data['content'] ?? [];

            // Ensure notificationsList is a list before mapping
            if (notificationsList is List) {
              return notificationsList
                  .map((json) => NotificationBroadcasterModel.fromJson(json))
                  .toList();
            } else {
              throw Exception('Unexpected content format: Expected a list of notifications');
            }
          },
        );

        return mainResponse;
      } else {
        _handleError(response);
        throw Exception('Failed to fetch notifications: ${response.body}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      throw e; // Rethrow the error to handle it in the calling code
    }
  }


  // Handles errors by printing the status code and body.
  void _handleError(http.Response response) {
    print('Error: ${response.statusCode} - ${response.body}');
  }
}
