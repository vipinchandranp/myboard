import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myboard/screens/websocket/request/websocket_main_response.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

mixin MBWebSocketMixin {
  StompClient? _stompClient;
  bool _isConnected = false;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final StreamController<MBWebSocketResponse> _messageController =
  StreamController<MBWebSocketResponse>.broadcast();

  // Getter to access connection status
  bool get isConnected => _isConnected;

  // Getter for message stream
  Stream<MBWebSocketResponse> get messageStream => _messageController.stream;

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
        onConnect: (frame) => _onStompConnect(frame, token),
        onDisconnect: (frame) {
          print('Disconnected from STOMP server.');
          _isConnected = false;
        },
        onStompError: (frame) => print('STOMP Error: ${frame.body}'),
        onWebSocketError: (error) => print('WebSocket Error: $error'),
        beforeConnect: () async {
          print('Bearer $token');
          print('Waiting to connect...');
          await Future.delayed(const Duration(milliseconds: 500));
          print('Connecting...');
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $token',
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

  // Callback when STOMP is connected
  Future<void> _onStompConnect(StompFrame frame, String token) async {
    print('Connected to STOMP server.');
    _isConnected = true;

    // Example subscription with Authorization header
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    _stompClient!.subscribe(
      headers: headers,
      destination: '/topic/register', // Adjust the topic if needed
      callback: (frame) {
        if (frame.body != null) {
          // Handle incoming message, parsing it correctly
          _handleIncomingMessage(frame.body!);
        }
      },
    );
  }

  // Handle incoming STOMP messages and parse them as WebSocketResponse
  void _handleIncomingMessage(String message) {
    try {
      // Decode the incoming message
      final Map<String, dynamic> messageMap = json.decode(message);

      // Convert the message to the WebSocket response model
      MBWebSocketResponse mbWebSocketResponse =
      MBWebSocketResponse.fromJson(messageMap);

      print('Received STOMP message: ${mbWebSocketResponse.toJson()}');

      // Emit the message to the stream
      _messageController.add(mbWebSocketResponse);
    } catch (e) {
      print('Error handling incoming message: $e');
    }
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

  // Dispose the mixin and close the stream
  void dispose() {
    _messageController.close();
  }
}
