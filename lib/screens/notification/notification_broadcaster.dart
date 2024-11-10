import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'notification_broadcaster_model.dart';

class NotificationBroadcaster {
  static final NotificationBroadcaster _instance =
      NotificationBroadcaster._internal();
  final StreamController<NotificationBroadcasterModel> _controller =
      StreamController.broadcast();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  WebSocketChannel? _channel;
  bool _isConnected = false;

  NotificationBroadcaster._internal(); // Private constructor for singleton

  factory NotificationBroadcaster() => _instance;

  Stream<NotificationBroadcasterModel> get notificationStream =>
      _controller.stream;

  // Connect method ensures only one connection is established with token
  Future<void> connect() async {
    if (!_isConnected) {
      final token = await _storage.read(key: 'jwtToken');
      print('Retrieved token: $token');

      if (token != null) {
        _isConnected = true;
        _startWebSocketConnection();
      } else {
        print('No token found. User is not logged in.');
      }
    }
  }

  // Establish WebSocket connection and listen for incoming messages
  void _startWebSocketConnection() {
    if (_channel == null) {
      _channel = IOWebSocketChannel.connect(
          'ws://192.168.1.43:8080/myboard/websocket');

      _channel!.stream.listen((message) {
        _handleIncomingMessage(message);
      }, onError: (error) {
        print('WebSocket error: $error');
        _disconnect(); // Close and reset connection on error
      }, onDone: () {
        print('WebSocket connection closed.');
        _disconnect(); // Close connection if server disconnects
      });
    } else {
      print('Already connected to WebSocket.');
    }
  }

  void _handleIncomingMessage(String message) {
    try {
      // Parse the JSON string into a Map<String, dynamic>
      final Map<String, dynamic> parsedJson = jsonDecode(message);

      // Convert parsed JSON into a NotificationBroadcasterModel instance
      final notification = NotificationBroadcasterModel.fromJson(parsedJson);

      // Broadcast the notification to all listeners
      _controller.add(notification);
    } catch (e) {
      print('Error parsing message: $message, Error: $e');
    }
  }

  // Manual disconnection from WebSocket
  void _disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null; // Reset channel
      _isConnected = false;
      print('Disconnected from WebSocket.');
    }
  }

  // Optional manual broadcasting for testing
  void broadcastNotification(NotificationBroadcasterModel notification) {
    if (_isConnected) {
      _controller.add(notification);
    }
  }

  // Dispose method to close resources
  void dispose() {
    _disconnect();
    _controller.close();
  }
}
