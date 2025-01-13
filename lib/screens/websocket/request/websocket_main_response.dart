import '../types/websocket_action_types.dart';

class MBWebSocketResponse<T> {
  final WebSocketAction action;
  final T data;

  MBWebSocketResponse({
    required this.action,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'action': action.actionValue, // Use action's string representation
      'data': data,
    };
  }

  factory MBWebSocketResponse.fromJson(Map<String, dynamic> json) {
    return MBWebSocketResponse(
      action: WebSocketAction.fromString(json['action'] as String),
      data: json['data'], // Generic type T must be handled correctly
    );
  }
}