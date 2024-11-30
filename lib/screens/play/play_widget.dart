import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../user/login_screen.dart';
import '../websocket/mbwebsocket_mixin.dart';

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

  @override
  void initState() {
    super.initState();
    print('PlayWidget initialized.');
    connect(); // Connect to the STOMP server

    // Send displayPin to the STOMP server after connection
    Future.delayed(Duration(seconds: 1), _sendRegisterDisplayRequest);
  }

  void _sendRegisterDisplayRequest() {
    sendMessage(
      '/app/register_display',
      {
        'action': 'register_display',
        'data': {'displayPin': widget.displayPin},
      },
    );
  }

  // Add other request methods as needed
  void _sendPlayContentRequest() {
    sendMessage(
      '/app/play_content',
      {
        'action': 'play_content',
        'data': {'displayPin': widget.displayPin},
      },
    );
  }

  @override
  void dispose() {
    print('PlayWidget disposed.');
    disconnect(); // Disconnect from STOMP server
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentBoardId ?? 'Currently Playing Board'),
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
        child: _currentBoardId == null
            ? const CircularProgressIndicator()
            : _buildBoardContent(),
      ),
    );
  }

  Widget _buildBoardContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_currentBoardId != null)
          Text(
            'Board ID: $_currentBoardId',
            style: const TextStyle(fontSize: 24),
          ),
      ],
    );
  }

  Widget _buildMediaContent(String? mediaPath) {
    if (mediaPath == null) {
      return const Text('No media available');
    } else if (isImage) {
      return Image.network(mediaPath);
    } else if (_videoController != null && _videoController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    } else {
      return const Text('Unsupported media type');
    }
  }
}
