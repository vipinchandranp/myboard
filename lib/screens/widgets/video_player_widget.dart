import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget { // Removed the underscore
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState(); // Updated name
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> { // Removed the underscore
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Update the UI once the video is initialized
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? GestureDetector(
      onTap: () {
        setState(() {
          _isPlaying = !_isPlaying;
          _isPlaying ? _controller.play() : _controller.pause();
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          if (!_isPlaying)
            const Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 64,
            ),
        ],
      ),
    )
        : const Center(child: CircularProgressIndicator());
  }
}
