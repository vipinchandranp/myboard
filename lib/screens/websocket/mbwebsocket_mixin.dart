import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

mixin MBWebSocketMixin {
  WebSocketChannel? _channel;
  bool _isConnected = false;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final StreamController<String> _controller = StreamController.broadcast();

  // Getter to access connection status
  bool get isConnected => _isConnected;

  // Stream to listen to incoming WebSocket messages
  Stream<String> get webSocketStream => _controller.stream;

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
      _channel = IOWebSocketChannel.connect('ws://192.168.1.43:8080/myboard/websocket');

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

  // Handle incoming messages and broadcast them to the stream
  void _handleIncomingMessage(String message) {
    _controller.add(message);
  }

  // Disconnect from WebSocket
  void _disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null; // Reset channel
      _isConnected = false;
      print('Disconnected from WebSocket.');
    }
  }

  // Dispose method to close resources
  void dispose() {
    _disconnect();
    _controller.close();
  }
}
