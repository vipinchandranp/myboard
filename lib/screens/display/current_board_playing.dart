import 'package:flutter/material.dart';
import 'dart:io';

import '../../models/display/currently_playing_boards_response.dart';
import '../../repository/display_repository.dart';

class CurrentBoardPlaying extends StatefulWidget {
  final String displayId;

  const CurrentBoardPlaying({Key? key, required this.displayId}) : super(key: key);

  @override
  _CurrentBoardPlayingState createState() => _CurrentBoardPlayingState();
}

class _CurrentBoardPlayingState extends State<CurrentBoardPlaying> {
  late DisplayService displayService;
  CurrentlyPlayingBoardsResponse? boardsResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    displayService = DisplayService(context);
    _fetchCurrentlyPlayingBoards();
  }

  // Fetch currently playing boards data
  Future<void> _fetchCurrentlyPlayingBoards() async {
    setState(() {
      isLoading = true;
    });

    CurrentlyPlayingBoardsResponse? response =
    await displayService.getCurrentlyPlayingBoards(widget.displayId);

    setState(() {
      boardsResponse = response;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Current Board Playing')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : boardsResponse == null
            ? Center(child: Text('Failed to load data'))
            : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Check for empty previouslyPlayed and show message if needed
            if (boardsResponse!.previouslyPlayed.isEmpty)
              Center(
                child: Text(
                  'Nothing got played recently',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            // Played media items
            for (String played in boardsResponse!.previouslyPlayed)
              MediaItemWidget(
                title: "Played",
                color: Colors.grey,
                icon: Icons.check,
                subtitle: "This is already played",
                startTime: "10:00 AM", // Replace with actual start time if available
                endTime: "11:00 AM",   // Replace with actual end time if available
              ),

            // Currently playing media items
            for (String playing in boardsResponse!.currentlyPlaying)
              MediaItemWidget(
                title: "Playing",
                color: Colors.blueAccent,
                icon: Icons.play_arrow,
                subtitle: "Currently playing",
                isPlaying: true,
                startTime: "11:00 AM", // Replace with actual start time if available
                endTime: "12:00 PM",   // Replace with actual end time if available
              ),

            // Upcoming media items
            for (String upcoming in boardsResponse!.upcoming)
              MediaItemWidget(
                title: "Upcoming",
                color: Colors.black45,
                icon: Icons.queue_music,
                subtitle: "Up next",
                startTime: "12:00 PM", // Replace with actual start time if available
                endTime: "01:00 PM",   // Replace with actual end time if available
              ),
          ],
        ),
      ),
    );
  }
}

class MediaItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final bool isPlaying;
  final String startTime;
  final String endTime;

  const MediaItemWidget({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.isPlaying = false,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 48),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 16, color: color.withOpacity(0.7)),
          ),
          if (isPlaying) ...[
            SizedBox(height: 12),
            Icon(Icons.graphic_eq, color: color, size: 32),
          ],
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Start: $startTime",
                style: TextStyle(fontSize: 16, color: color),
              ),
              Text(
                "End: $endTime",
                style: TextStyle(fontSize: 16, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
