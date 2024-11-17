import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../models/play/TimeSlotBoardToBePlayed.dart';
import '../../repository/play_repository.dart';
import '../user/login_screen.dart';

class PlayWidget extends StatefulWidget {
  final String displayPin;

  PlayWidget({required this.displayPin});

  @override
  _PlayWidgetState createState() => _PlayWidgetState();
}

class _PlayWidgetState extends State<PlayWidget> {
  late PlayService _playService;
  TimeSlotBoardToBePlayed? _currentBoard;
  late Timer _timer;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _playService = PlayService(context);

    // Fetch the board for display initially
    _fetchBoard();

    // Set up a timer to fetch the board every minute
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _fetchBoard();
    });
  }

  Future<void> _fetchBoard() async {
    TimeSlotBoardToBePlayed? board = await _playService.getBoardForDisplay(widget.displayPin);
    if (board != null) {
      setState(() {
        _currentBoard = board;
      });
      _initializeMedia(board.boardMediaPath);  // Initialize media based on the URL
    } else {
      print("Failed to fetch the board.");
    }
  }

  void _initializeMedia(String? mediaPath) {
    // Dispose any previous video controller
    _videoController?.dispose();

    if (mediaPath != null) {
      if (mediaPath.endsWith('.mp4')) {
        // Initialize video controller for video URL
        _videoController = VideoPlayerController.network(mediaPath)
          ..initialize().then((_) {
            setState(() {});
            _videoController!.play();  // Autoplay video
          });
      }
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currently Playing Board"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchBoard,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: _currentBoard == null
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Board Name: ${_currentBoard!.boardName}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            _buildMediaContent(_currentBoard!.boardMediaPath),  // Display media
            SizedBox(height: 20),
            Text(
              'Display Name: ${_currentBoard!.displayName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display media based on URL
  Widget _buildMediaContent(String? mediaPath) {
    if (mediaPath == null) {
      return Text('No media available');
    } else if (mediaPath.endsWith('.jpg') || mediaPath.endsWith('.png')) {
      // Display image from URL
      return Image.network(mediaPath);
    } else if (mediaPath.endsWith('.mp4') && _videoController != null && _videoController!.value.isInitialized) {
      // Display video if URL points to a video and is initialized
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    } else {
      return Text('Unsupported media type');
    }
  }
}
