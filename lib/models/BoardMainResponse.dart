import 'package:flutter/foundation.dart';

enum MessageType { INFO, WARNING, ERROR }

class BoardMainResponse<T> {
  T? data;
  Map<MessageType, List<String>>? messages;

  BoardMainResponse({this.data, this.messages});

  BoardMainResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    messages = (json['messages'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(
        MessageType.values[int.parse(key)],
        List<String>.from(value),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['data'] = this.data;
    data['messages'] = this.messages?.map(
          (key, value) => MapEntry(
            MessageType.values.indexOf(key).toString(),
            value,
          ),
        );
    return data;
  }
}
