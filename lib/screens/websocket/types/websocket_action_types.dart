import 'dart:convert';

// Define the WebSocketAction enum
enum WebSocketAction {
  registerDisplay("register_display"),
  playContent("play_content"),
  stopContent("stop_content"),
  unknown("unknown"); // For unrecognized actions

  // The action string associated with each enum value
  final String action;

  // Constructor
  const WebSocketAction(this.action);

  // Getter for the action string
  String getAction() {
    return action;
  }

  // Method to get enum from string (for parsing incoming messages)
  static WebSocketAction fromString(String action) {
    // Iterate through the enum values and match the action string
    for (var type in WebSocketAction.values) {
      if (type.getAction().toLowerCase() == action.toLowerCase()) {
        return type;
      }
    }
    return WebSocketAction.unknown; // Return unknown if action doesn't match
  }

  // Method to convert enum to its string representation
  static String toActionString(WebSocketAction action) {
    return action.getAction();
  }
}