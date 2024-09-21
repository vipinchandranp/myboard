import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'message_type.dart';

// Define the MainResponse class with generic type T
class MainResponse<T> {
  final T data;
  final Map<MessageType, List<String>> messages;

  MainResponse({
    required this.data,
    required this.messages,
  });

  // Factory constructor to create MainResponse from JSON
  factory MainResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    // Parse the data
    final dataJson = json['data'] as Map<String, dynamic>;
    final messagesJson = json['messages'] as Map<String, dynamic>;

    // Convert messages to a Map of MessageType and List<String>
    final Map<MessageType, List<String>> messages = {};
    messagesJson.forEach((key, value) {
      final messageType = _messageTypeFromString(key);
      if (messageType != null) {
        messages[messageType] = List<String>.from(value);
      }
    });

    return MainResponse<T>(
      data: fromJsonT(dataJson),
      messages: messages,
    );
  }

  // Helper method to convert string to MessageType
  static MessageType? _messageTypeFromString(String key) {
    switch (key) {
      case 'INFO':
        return MessageType.INFO;
      case 'WARNING':
        return MessageType.WARNING;
      case 'ERROR':
        return MessageType.ERROR;
      default:
        return null;
    }
  }

  // Convert MainResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': data, // Convert data to JSON using appropriate method
      'messages': messages.map((key, value) {
        return MapEntry(
          _messageTypeToString(key),
          value,
        );
      }),
    };
  }

  // Helper method to convert MessageType to string
  String _messageTypeToString(MessageType key) {
    switch (key) {
      case MessageType.INFO:
        return 'INFO';
      case MessageType.WARNING:
        return 'WARNING';
      case MessageType.ERROR:
        return 'ERROR';
    }
  }
}
