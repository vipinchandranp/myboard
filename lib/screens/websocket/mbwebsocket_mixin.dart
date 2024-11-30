import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

mixin MBWebSocketMixin {
  StompClient? _stompClient;
  bool _isConnected = false;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Getter to access connection status
  bool get isConnected => _isConnected;

  // Connect method ensures only one connection is established with token
  Future<void> connect() async {
    print('connect() called');
    if (!_isConnected) {
      final token = await _storage.read(key: 'jwtToken');
      print('Retrieved token: $token');

      if (token != null) {
        print('Starting STOMP connection...');
        _startStompConnection(token);
      } else {
        print('No token found. User is not logged in.');
      }
    } else {
      print('Already connected.');
    }
  }

  // Initialize the STOMP connection
  void _startStompConnection(String token) {
    _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://192.168.1.43:8080/myboard/websocket',
        onConnect: _onStompConnect,
        onDisconnect: (frame) {
          print('Disconnected from STOMP server.');
          _isConnected = false;
        },
        onStompError: (frame) => print('STOMP Error: ${frame.body}'),
        onWebSocketError: (error) => print('WebSocket Error: $error'),
        beforeConnect: () async {
          print('Waiting to connect...');
          await Future.delayed(const Duration(milliseconds: 500));
          print('Connecting...');
        },
        stompConnectHeaders: {
          'Authorization': 'Bearer $token',
        },
        heartbeatOutgoing: const Duration(seconds: 10),
        heartbeatIncoming: const Duration(seconds: 10),
      ),
    );

    _stompClient!.activate();
  }

  // Callback when STOMP is connected
  void _onStompConnect(StompFrame frame) {
    print('Connected to STOMP server.');
    _isConnected = true;

    // Example subscription (adjust as needed)
    _stompClient!.subscribe(
      destination: '/topic/register',
      callback: (frame) {
        if (frame.body != null) {
          _handleIncomingMessage(frame.body!);
        }
      },
    );
  }

  // Send message over STOMP
  void sendMessage(String destination, Map<String, dynamic> body) {
    if (_stompClient != null && _isConnected) {
      print('Sending message to $destination: $body');
      _stompClient!.send(
        destination: destination,
        body: json.encode(body),
      );
    } else {
      print('STOMP client is not connected.');
    }
  }

  // Handle incoming STOMP messages
  void _handleIncomingMessage(String message) {
    print('Received STOMP message: $message');
    // Implement message handling logic
  }

  // Disconnect the STOMP client
  void disconnect() {
    if (_stompClient != null) {
      print('Disconnecting from STOMP server...');
      _stompClient!.deactivate();
      _stompClient = null;
      _isConnected = false;
    }
  }
}
