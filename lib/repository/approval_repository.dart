import 'dart:convert';
import 'package:flutter/material.dart';
import '../api_models/timeslot_status_response.dart';
import 'base_repository.dart';

class ApprovalService extends BaseRepository {
  ApprovalService(BuildContext context) : super(context);

  // Fetch timeslot status for the logged-in user
  Future<List<TimeslotStatusResponse>?> getTimeslotStatus() async {
    try {
      // Construct the API URL
      final url = Uri.parse('$apiUrl/timeslot/status');

      // Perform the GET request
      final response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode the JSON response
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Extract the 'data' field which contains the list of timeslot status responses
        final List<dynamic> responseBodyList = responseBody['data'];

        // Debugging: print raw response list
        print('Response data: $responseBodyList');

        // Convert the list of JSON objects into TimeslotStatusResponse objects
        final List<TimeslotStatusResponse> timeslotStatusList = responseBodyList
            .map(
                (timeslotJson) => TimeslotStatusResponse.fromJson(timeslotJson))
            .toList();

        return timeslotStatusList;
      } else {
        handleError(response); // Handles any non-200 response codes
        return null;
      }
    } catch (e) {
      print('Error fetching timeslot status: $e');
      return null;
    }
  }

  Future<bool> updateTimeslotApproval(String timeslotId, bool isApproved) async {
    try {
      final url = Uri.parse('$apiUrl/timeslot/approval/update?timeslotId=$timeslotId&isApproved=$isApproved');
      final response = await client.put(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true; // Successfully updated
      } else {
        handleError(response);
        return false; // Failed to update
      }
    } catch (e) {
      print('Error updating timeslot approval: $e');
      return false; // Exception occurred
    }
  }
}
