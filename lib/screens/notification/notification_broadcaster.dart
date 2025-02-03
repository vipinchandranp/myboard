import 'dart:async';
import 'dart:convert';
import '../websocket/mbwebsocket_mixin.dart';
import 'notification_broadcaster_model.dart';

class NotificationBroadcaster /*with MBWebSocketMixin*/ {
  static final NotificationBroadcaster _instance = NotificationBroadcaster._internal();
  final StreamController<NotificationBroadcasterModel> _controller =
  StreamController.broadcast();

  NotificationBroadcaster._internal(); // Private constructor for singleton

  factory NotificationBroadcaster() => _instance;

  Stream<NotificationBroadcasterModel> get notificationStream => _controller.stream;

  @override
  Future<void> connect() async {
    //await super.connect();  // Connect using the MBWebSocketMixin
    // Additional logic (if needed) after WebSocket connection
  }

  // Handle incoming WebSocket message and broadcast as NotificationBroadcasterModel
  @override
  void _handleIncomingMessage(String message) {
    try {
      final Map<String, dynamic> parsedJson = jsonDecode(message);
      final notification = NotificationBroadcasterModel.fromJson(parsedJson);
      _controller.add(notification);  // Broadcast notification to listeners
    } catch (e) {
      print('Error parsing message: $message, Error: $e');
    }
  }

  // Optional manual broadcasting for testing
  void broadcastNotification(NotificationBroadcasterModel notification) {
    /*if (isConnected) {
      _controller.add(notification);
    }*/
  }

  @override
  void dispose() {
   /* super.disconnect();
    _controller.close();*/
  }
}
