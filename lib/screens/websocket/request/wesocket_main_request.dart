// Import the WebSocketAction enum
import '../types/websocket_action_types.dart';

// Define a generic WebSocket request model
class MBWebSocketRequest {
  final String destination;
  final Map<String, dynamic> body;

  // Constructor
  MBWebSocketRequest({
    required this.destination,
    required this.body,
  });

  // Convert the MBWebSocketRequest instance to a Map (for JSON encoding)
  Map<String, dynamic> toJson() {
    return {
      'destination': destination,
      'body': body,
    };
  }

  // Create a MBWebSocketRequest instance from a Map (for JSON decoding)
  factory MBWebSocketRequest.fromJson(Map<String, dynamic> json) {
    return MBWebSocketRequest(
      destination: json['destination'] as String,
      body: json['body'] as Map<String, dynamic>,
    );
  }
}
