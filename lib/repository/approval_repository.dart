import 'dart:convert';
import 'package:flutter/material.dart';
import '../api_models/timeslot_status_response.dart';
import '../api_models/timslot_status_request.dart';
import 'base_repository.dart';

class ApprovalService extends BaseRepository {
  ApprovalService(BuildContext context) : super(context);

// New method to fetch filtered timeslots based on request
  Future<List<TimeslotStatusResponse>?> fetchFilteredTimeslots(
      TimeslotStatusRequest request) async {
    try {
      print('Request data: ' + jsonEncode(request.toJson()));

      // Construct the API URL
      final url =
          Uri.parse('$apiUrl/timeslot/status'); // Adjust the endpoint as needed

      // Perform the POST request with filter criteria
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()), // Encode the request to JSON
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode the JSON response directly as a List of dynamic objects
        final List<dynamic> responseBodyList = json.decode(response.body);

        // Debugging: print raw response list
        print('Filtered Response data: $responseBodyList');

        // Convert the list of JSON objects into TimeslotStatusResponse objects
        final List<TimeslotStatusResponse> filteredTimeslotStatusList =
            responseBodyList
                .map((timeslotJson) =>
                    TimeslotStatusResponse.fromJson(timeslotJson))
                .toList();

        return filteredTimeslotStatusList;
      } else {
        handleError(response); // Handles any non-200 response codes
        return null;
      }
    } catch (e) {
      print('Error fetching filtered timeslots: $e');
      return null;
    }
  }

  Future<bool> updateTimeslotApproval(
      String timeslotId, bool isApproved) async {
    try {
      final url = Uri.parse(
          '$apiUrl/timeslot/approval/update?timeslotId=$timeslotId&isApproved=$isApproved');
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

  Future<List<DateTime>?> fetchAvailableDates() async {
    try {
      final url = Uri.parse('$apiUrl/timeslot/available-dates');
      final response = await client.get(url);

      // Print the response body for debugging
      print('Response body: ${response.body}');

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode the response body as List<List<int>>
        final List<dynamic> responseBodyList = json.decode(response.body);

        // Convert the list of lists into DateTime objects
        final List<DateTime> availableDates = responseBodyList.map((dateArray) {
          // Ensure each dateArray is treated as List<int>
          final List<int> dateParts = List<int>.from(dateArray);
          return DateTime(
              dateParts[0], dateParts[1], dateParts[2]); // year, month, day
        }).toList();

        return availableDates;
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching available dates: $e');
      return null;
    }
  }
}
