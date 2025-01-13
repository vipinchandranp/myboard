
// Define the WebSocketAction enum
enum WebSocketAction {
  registerDisplay("register_display"),
  playContent("play_content"),
  stopContent("stop_content"),
  qr_code("qr_code"),
  unknown("unknown"); // For unrecognized actions

  final String action;

  const WebSocketAction(this.action);

  String get actionValue => action;

  static WebSocketAction fromString(String action) {
    return WebSocketAction.values.firstWhere(
          (type) => type.actionValue.toLowerCase() == action.toLowerCase(),
      orElse: () => WebSocketAction.unknown,
    );
  }
}