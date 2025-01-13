import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../user/login_screen.dart';
import '../websocket/mbwebsocket_mixin.dart';
import '../websocket/request/websocket_main_response.dart';
import '../websocket/types/websocket_action_types.dart';

class PlayWidget extends StatefulWidget {
  final String displayPin;

  const PlayWidget({Key? key, required this.displayPin}) : super(key: key);

  @override
  _PlayWidgetState createState() => _PlayWidgetState();
}

class _PlayWidgetState extends State<PlayWidget> with MBWebSocketMixin {
  VideoPlayerController? _videoController;
  String? _currentBoardId;
  DateTime? _endTime;
  bool isImage = false;

  // Variable to hold the WebSocket message stream subscription
  late StreamSubscription<MBWebSocketResponse> _messageSubscription;

  // Variables to store QR code data and message
  String? _qrCodeBase64;
  String? _qrCodeMessage;

  @override
  void initState() {
    super.initState();
    print('PlayWidget initialized.');

    // Connect to the WebSocket server
    connect();

    // Send displayPin to the STOMP server after connection
    Future.delayed(Duration(seconds: 1), _sendRegisterDisplayRequest);

    // Listen to the WebSocket message stream
    _messageSubscription = messageStream.listen((message) {
      onMessageReceived(message);
    });
  }

  @override
  void dispose() {
    print('PlayWidget disposed.');

    // Cancel the subscription when the widget is disposed
    _messageSubscription.cancel();

    // Disconnect from STOMP server and clean up
    disconnect();

    _videoController?.dispose();
    super.dispose();
  }

  // Handle messages received from the WebSocket server
  void onMessageReceived(MBWebSocketResponse decodedMessage) {
    try {
      switch (decodedMessage.action) {
        case WebSocketAction.registerDisplay:
          _handleRegisterDisplay(decodedMessage.data);
          break;
        case WebSocketAction.playContent:
          _handlePlayContent(decodedMessage.data);
          break;
        case WebSocketAction.stopContent:
          _handleStopContent(decodedMessage.data);
          break;
        case WebSocketAction.qr_code:
          _handleQrCode(decodedMessage.data);
          break;
        case WebSocketAction.unknown:
        default:
          print('Unknown action received: ${decodedMessage.action}');
      }
    } catch (e) {
      print('Error parsing WebSocket message: $e');
    }
  }

  // Handle the register display action
  void _handleRegisterDisplay(Map<String, dynamic> data) {
    setState(() {
      _currentBoardId = data['boardId'] as String?;
    });
    print('Register display successful. Board ID: $_currentBoardId');
  }

  // Handle play content action
  void _handlePlayContent(Map<String, dynamic> data) {
    final mediaPath = data['mediaPath'] as String?;
    final mediaType = data['mediaType'] as String?;

    if (mediaPath != null) {
      setState(() {
        isImage = mediaType == 'image';
        if (!isImage) {
          _videoController = VideoPlayerController.network(mediaPath)
            ..initialize().then((_) {
              setState(() {});
              _videoController!.play();
            });
        }
      });
    }
    print('Play content: $mediaPath');
  }

  // Handle stop content action
  void _handleStopContent(Map<String, dynamic> data) {
    setState(() {
      _currentBoardId = null;
      _videoController?.pause();
      _videoController?.dispose();
      _videoController = null;
    });
    print('Content stopped.');
  }

  // Handle qr_code action
  void _handleQrCode(Map<String, dynamic> data) {
    final qrCode = data['qrCode'] as String?;
    final message = data['message'] as String?;

    if (qrCode != null && message != null) {
      setState(() {
        _qrCodeBase64 = qrCode;
        _qrCodeMessage = message;
      });
    }
    print('Received QR code and message: $qrCode, $message');
  }

  // Send the register display request to the server
  void _sendRegisterDisplayRequest() {
    sendMessage(
      '/app/register_display',
      {
        'action': WebSocketAction.registerDisplay.actionValue, // Corrected to use actionValue
        'data': {'displayPin': widget.displayPin},
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       // title: Text(_currentBoardId ?? 'Currently Playing Board'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: (_currentBoardId == null && _qrCodeBase64 == null)
            ? const CircularProgressIndicator()
            : _buildBoardContent(),
      ),
    );
  }

  Widget _buildBoardContent() {
    if (_qrCodeBase64 != null && _qrCodeMessage != null) {
      return _buildQrCodeContent();
    } else if (_currentBoardId != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Board ID: $_currentBoardId',
            style: const TextStyle(fontSize: 24),
          ),
          _buildMediaContent(),
        ],
      );
    } else {
      return const Text('No content available.');
    }
  }


  Widget _buildMediaContent() {
    // Display image or video based on media type
    if (isImage) {
      return const CircularProgressIndicator(); // Placeholder for loading image
    } else if (_videoController != null && _videoController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    } else {
      return const Text('Unsupported media type');
    }
  }

  Widget _buildQrCodeContent() {
    // Decode the QR code from base64 and display it
    final qrImage = base64Decode(_qrCodeBase64!);

    return Column(
      children: [
        Image.memory(qrImage), // Display the decoded QR code
        const SizedBox(height: 20),
        Text(
          _qrCodeMessage ?? 'No message available.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
