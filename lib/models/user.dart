import 'location.dart'; // Import the Location class

class MyBoardUser {
  final String id;
  final String username;
  final Location? location; // Include the Location field

  MyBoardUser({
    required this.id,
    required this.username,
    this.location,
  });

  // Convert a Map (from MongoDB) to a MyBoardUser
  factory MyBoardUser.fromMap(Map<String, dynamic> map) {
    return MyBoardUser(
      id: map['id'],
      username: map['username'],
      location: map['location'] != null
          ? Location.fromMap(map['location'])
          : null,
    );
  }

  // Convert a MyBoardUser to a Map (for MongoDB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'location': location?.toMap(), // Convert Location to Map
    };
  }
}
