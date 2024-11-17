import 'dart:convert';

class CurrentlyPlayingBoardsResponse {
  final List<String> currentlyPlaying;
  final List<String> previouslyPlayed;
  final List<String> upcoming;

  CurrentlyPlayingBoardsResponse({
    required this.currentlyPlaying,
    required this.previouslyPlayed,
    required this.upcoming,
  });

  // Factory constructor to create an instance of CurrentlyPlayingBoardsResponse from JSON
  factory CurrentlyPlayingBoardsResponse.fromJson(Map<String, dynamic> json) {
    return CurrentlyPlayingBoardsResponse(
      currentlyPlaying: List<String>.from(json['currentlyPlaying'] ?? []),
      previouslyPlayed: List<String>.from(json['previouslyPlayed'] ?? []),
      upcoming: List<String>.from(json['upcoming'] ?? []),
    );
  }

  // Method to convert this instance to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'currentlyPlaying': currentlyPlaying,
      'previouslyPlayed': previouslyPlayed,
      'upcoming': upcoming,
    };
  }
}

// Helper function to parse JSON string into CurrentlyPlayingBoardsResponse object
CurrentlyPlayingBoardsResponse parseCurrentlyPlayingBoardsResponse(String responseBody) {
  final parsed = json.decode(responseBody);
  return CurrentlyPlayingBoardsResponse.fromJson(parsed);
}
