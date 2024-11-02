import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myboard/screens/user/login_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class MyWebSocketApp extends StatefulWidget {
  @override
  _MyWebSocketAppState createState() => _MyWebSocketAppState();
}

class _MyWebSocketAppState extends State<MyWebSocketApp> {
  late WebSocketChannel channel;
  String receivedMessage =
      'Waiting for notifications...'; // For displaying notifications
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? token; // To store the JWT token for printing
  bool isConnected = false; // Track WebSocket connection status

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  Future<String?> _getToken() async {
    String? token = await _storage.read(key: 'jwtToken');
    print('Retrieved token: $token'); // Print the retrieved token
    return token;
  }

  void _connectWebSocket() async {
    token = await _getToken(); // Get the token

    if (token != null) {
      channel = IOWebSocketChannel.connect(
          'ws://192.168.1.43:8080/myboard/websocket');
      setState(() {
        isConnected = true; // Update connection status
      });

      channel.stream.listen((message) {
        setState(() {
          receivedMessage = message; // Update received message
        });
        print('Received message: $message'); // Log the received message
      }, onError: (error) {
        print('WebSocket error: $error');
      }, onDone: () {
        setState(() {
          isConnected = false; // Update connection status
        });
      });
    } else {
      print('No token found. User is not logged in.');
    }
  }

  @override
  void dispose() {
    channel.sink.close(); // Close the WebSocket channel on dispose
    super.dispose();
  }

  void _logout() {
    if (isConnected) {
      channel.sink.close(); // Disconnect the WebSocket
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
    // Navigate to your login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebSocket Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(receivedMessage), // Display the received notification
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout, // Call the logout method
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
