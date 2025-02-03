import 'dart:async'; // For Timer
import 'dart:convert'; // For base64Decode
import 'dart:typed_data'; // For Uint8List
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../models/play/TimeSlotBoardToBePlayed.dart';
import '../../repository/play_repository.dart';
import '../user/login_screen.dart';

class PlayWidget extends StatefulWidget {
  final String displayPin;

  const PlayWidget({Key? key, required this.displayPin}) : super(key: key);

  @override
  _PlayWidgetState createState() => _PlayWidgetState();
}

class _PlayWidgetState extends State<PlayWidget> {
  VideoPlayerController? _videoController;
  String? _currentBoardId;
  bool isImage = false;
  TimeSlotBoardToBePlayed? _timeSlotBoard;
  late PlayService _playService;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    print('PlayWidget initialized.');
    _playService = PlayService(context);

    // Fetch the board content for the first time
    _fetchBoardContent();

    // Set up a timer to call the service every 1 minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _fetchBoardContent();
    });
  }

  @override
  void dispose() {
    print('PlayWidget disposed.');
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _videoController?.dispose();
    super.dispose();
  }

  // Fetch the board content from the REST API
  Future<void> _fetchBoardContent() async {
    try {
      final content = await _playService.getBoardForDisplay(widget.displayPin);
      if (content != null) {
        setState(() {
          _timeSlotBoard = content;
          _currentBoardId = content.boardId;

          // Determine if media path is for an image
          if (content.boardMediaPath != null) {
            final mediaPath = content.boardMediaPath!;
            final extension = mediaPath.split('.').last.toLowerCase();
            isImage = ['jpg', 'jpeg', 'png', 'gif'].contains(extension);

            // Initialize video controller for non-image media
            if (!isImage) {
              _videoController?.dispose(); // Dispose of the previous controller
              _videoController = VideoPlayerController.network(mediaPath)
                ..initialize().then((_) {
                  setState(() {});
                  _videoController!.play();
                });
            }
          }
        });
      } else {
        print('No board content available.');
      }
    } catch (e) {
      print('Error fetching board content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _timeSlotBoard == null
            ? const CircularProgressIndicator()
            : _buildBoardContent(),
      ),
    );
  }

  Widget _buildBoardContent() {
    if (_timeSlotBoard!.boardMediaPath == null &&
        _timeSlotBoard!.displayQrCode != null) {
      return _buildQrCodeContent();
    } else {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMediaContent(),
          ],
        ),
      );
    }
  }

  Widget _buildMediaContent() {
    if (isImage) {
      // Display image content
      return Image.network(
        _timeSlotBoard!.boardMediaPath!,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const CircularProgressIndicator();
        },
        errorBuilder: (context, error, stackTrace) {
          return const Text('Failed to load image');
        },
      );
    } else if (_videoController != null && _videoController!.value.isInitialized) {
      // Display video content
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    } else if (_timeSlotBoard!.displayQrCode != null) {
      // Fallback to QR code content
      return _buildQrCodeContent();
    } else {
      return const Text('Unsupported media type');
    }
  }
  Widget _buildQrCodeContent() {
    try {
      // Use the NativeUint8List directly
      final Uint8List qrImageBytes = _timeSlotBoard!.displayQrCode!;
      final String qrMessage = _timeSlotBoard!.message ?? 'Scan the QR code below';

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the QR code image
          Image.memory(qrImageBytes),
          const SizedBox(height: 20),
          // Display the message below the QR code
          Text(
            qrMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      );
    } catch (e) {
      // Handle errors gracefully
      return const Text(
        'Failed to load QR code',
        style: TextStyle(fontSize: 18, color: Colors.red),
      );
    }
  }

}
