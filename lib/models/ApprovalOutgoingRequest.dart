import 'package:flutter/material.dart';

class ApprovalOutgoingRequest {

  // Existing properties
  String id;
  String boardTitle;
  String displayTitle; // New property for display title
  String displayOwnerUserId;
  String displayOwnerUserName;
  String requesterName;
  DateTime requestDate;
  String requesterUserId;
  String boardId;
  String displayId;

  // New properties
  TimeOfDay startTime;
  TimeOfDay endTime;
  bool isApproved;

  ApprovalOutgoingRequest({
    required this.id,
    required this.boardTitle,
    required this.displayTitle,
    required this.displayOwnerUserId,
    required this.displayOwnerUserName,
    required this.requesterName,
    required this.requestDate,
    required this.requesterUserId,
    required this.boardId,
    required this.displayId,
    required this.startTime, // New property for start time
    required this.endTime, // New property for end time
    this.isApproved = false, // Default value for isApproved
  });

  // Getter and setter for isApproved
  bool getApproved() {
    return isApproved;
  }

  void setApproved(bool value) {
    isApproved = value;
  }

  factory ApprovalOutgoingRequest.fromJson(Map<String, dynamic> json) {
    return ApprovalOutgoingRequest(
      id: json['id'],
      boardTitle: json['boardTitle'],
      displayTitle: json['displayTitle'], // Parse display title from JSON
      displayOwnerUserId: json['displayOwnerUserId'],
      displayOwnerUserName: json['displayOwnerUserName'],
      requesterName: json['requesterName'],
      requestDate: DateTime.parse(json['requestDate']),
      requesterUserId: json['requesterUserId'],
      boardId: json['boardId'],
      displayId: json['displayId'],
      startTime: _parseTime(json['startTime']), // Parse start time
      endTime: _parseTime(json['endTime']), // Parse end time
      isApproved: json['isApproved'] ?? false, // Parse isApproved from JSON, default to false if not present
    );
  }

  // Method to parse TimeOfDay from string
  static TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
