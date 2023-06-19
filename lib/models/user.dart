class MyBoardUser {
  final String id;
  final String username;

  MyBoardUser({required this.id, required this.username});

  // Convert a Map (from MongoDB) to a MyBoardUser
  factory MyBoardUser.fromMap(Map<String, dynamic> map) {
    return MyBoardUser(id: map['id'], username: map['username']);
  }

  // Convert a MyBoardUser to a Map (for MongoDB)
  Map<String, dynamic> toMap() {
    return {'id': id, 'username': username};
  }
}
