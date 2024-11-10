import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'message_type.dart';

// MainResponse class with pagination support
class MainResponse<T> {
  final T? data;
  final Map<MessageType, List<String>> messages;
  final Pageable? pageable;
  final bool last;
  final int totalElements;
  final int totalPages;
  final bool first;
  final int size;
  final int number;
  final int numberOfElements;
  final bool empty;

  MainResponse({
    this.data,
    this.messages = const {},
    this.pageable,
    this.last = false,
    this.totalElements = 0,
    this.totalPages = 0,
    this.first = false,
    this.size = 0,
    this.number = 0,
    this.numberOfElements = 0,
    this.empty = false,
  });

  factory MainResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    // Parse the data if available
    final dataJson = json['data'] as Map<String, dynamic>?;
    final messagesJson = json['messages'] as Map<String, dynamic>?;

    // Convert messages to a Map of MessageType and List<String>
    final Map<MessageType, List<String>> messages = {};
    if (messagesJson != null) {
      messagesJson.forEach((key, value) {
        final messageType = _messageTypeFromString(key);
        if (messageType != null) {
          messages[messageType] = List<String>.from(value);
        }
      });
    }

    // Safely handle pagination fields
    return MainResponse<T>(
      data: dataJson != null ? fromJsonT(dataJson) : null, // Null safe handling for data
      messages: messages,
      pageable: json['pageable'] != null
          ? Pageable.fromJson(json['pageable'] as Map<String, dynamic>)
          : null, // Safe null check for pageable
      last: json['last'] as bool? ?? false,
      totalElements: json['totalElements'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      first: json['first'] as bool? ?? false,
      size: json['size'] as int? ?? 0,
      number: json['number'] as int? ?? 0,
      numberOfElements: json['numberOfElements'] as int? ?? 0,
      empty: json['empty'] as bool? ?? false,
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
      'data': data != null ? (data as dynamic).toJson() : null,
      'messages': messages.map((key, value) {
        return MapEntry(_messageTypeToString(key), value);
      }),
      'pageable': pageable?.toJson(),
      'last': last,
      'totalElements': totalElements,
      'totalPages': totalPages,
      'first': first,
      'size': size,
      'number': number,
      'numberOfElements': numberOfElements,
      'empty': empty,
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

// Pageable class for pagination details
class Pageable {
  final int offset;
  final int pageSize;
  final int pageNumber;
  final bool paged;
  final bool unpaged;

  Pageable({
    required this.offset,
    required this.pageSize,
    required this.pageNumber,
    required this.paged,
    required this.unpaged,
  });

  // Factory constructor to create Pageable from JSON
  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      offset: json['offset'] as int? ?? 0,
      pageSize: json['pageSize'] as int? ?? 0,
      pageNumber: json['pageNumber'] as int? ?? 0,
      paged: json['paged'] as bool? ?? false,
      unpaged: json['unpaged'] as bool? ?? false,
    );
  }

  // Convert Pageable to JSON
  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'pageSize': pageSize,
      'pageNumber': pageNumber,
      'paged': paged,
      'unpaged': unpaged,
    };
  }
}
