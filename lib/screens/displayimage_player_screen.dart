import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:myboard/repositories/display_repository.dart';
import 'package:myboard/repositories/user_repository.dart';

class DisplayImagePlayer extends StatefulWidget {
  @override
  _DisplayImagePlayerState createState() => _DisplayImagePlayerState();
}

class _DisplayImagePlayerState extends State<DisplayImagePlayer> {
  late List<int> _imageBytes;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _imageBytes = [];
    _loadDisplayImage();

    // Start the timer to reload the image every one minute
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _loadDisplayImage();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  void _loadDisplayImage() async {
    try {
      // Fetch the display image bytes using the userId
      List<int> displayImageBytes = [];
      if (_imageBytes.isEmpty) {
        // If _imageBytes is empty, fetch the QR code image
        displayImageBytes = await DisplayRepository().getDisplayImageQRCode();
      } else {
        // If _imageBytes is not empty, fetch the display image
        displayImageBytes =
            await UserRepository().getDisplayImageForCurrentTime();
      }

      setState(() {
        _imageBytes = displayImageBytes;
      });
    } catch (e) {
      print('Failed to fetch display image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(16.0), // Adjust padding as needed
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black,
                    width: 2.0), // Add border for better visibility
              ),
              child: Image.memory(
                Uint8List.fromList(_imageBytes),
                fit: BoxFit.contain,
                // Ensure the QR code fits within the container
                width: MediaQuery.of(context).size.width * 0.8,
                // Set width to 80% of screen width
                height: MediaQuery.of(context).size.height *
                    0.6, // Set height to 60% of screen height
              ),
            ),
          ),
        ],
      ),
    );
  }
}
