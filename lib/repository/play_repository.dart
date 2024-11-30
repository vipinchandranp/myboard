import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/play/TimeSlotBoardToBePlayed.dart';
import 'base_repository.dart';

class PlayService extends BaseRepository {
  PlayService(BuildContext context) : super(context);

  // Method to get the board to be played based on the display pin
  Future<TimeSlotBoardToBePlayed?> getBoardForDisplay(String displayPin) async {
    try {
      final response = await client.get(
        Uri.parse('$apiUrl/timeslot/play/board?displayPin=$displayPin'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return TimeSlotBoardToBePlayed.fromJson(data['data']);
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching board for display: $e');
      return null;
    }
  }

  // Method to mark the content as played
  Future<bool> markAsPlayed(String boardId) async {
    try {
      final response = await client.post(
        Uri.parse('$apiUrl/timeslot/play/mark_as_played'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'boardId': boardId}),
      );

      if (response.statusCode == 200) {
        print("Content marked as played successfully.");
        return true;
      } else {
        handleError(response);
        return false;
      }
    } catch (e) {
      print('Error marking content as played: $e');
      return false;
    }
  }
}
