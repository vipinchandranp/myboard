import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import '../config/api_config.dart';
import '../types/notification_type.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  WebSocketChannel? _channel;
  final StreamController<String> _messageController =
      StreamController<String>.broadcast();

  factory WebSocketService() {
    return _instance;
  }

  WebSocketService._internal();

  void connect() {
    String url = APIConfig.getWebSocketUrl();
    _channel = IOWebSocketChannel.connect(url);

    _channel!.stream.listen((message) {
      _handleIncomingMessage(message);
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
      dispose(); // Clean up on close
    });
  }

  Stream<String> get notificationStream => _messageController.stream;

  void _handleIncomingMessage(String message) {
    try {
      _messageController.add(message); // Notify listeners
    } catch (e) {
      print('Error processing message: $e');
    }
  }

  void dispose() {
    _messageController.close(); // Close the stream controller
    _channel?.sink.close(); // Close the WebSocket channel
  }
}
