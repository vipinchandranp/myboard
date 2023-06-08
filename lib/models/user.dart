class MyBoardUser {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;

  MyBoardUser({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
  });

  // Convert a Map (from MongoDB) to a MyBoardUser
  factory MyBoardUser.fromMap(Map<String, dynamic> map) {
    return MyBoardUser(
      id: map['_id'],
      email: map['email'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
    );
  }

  // Convert a MyBoardUser to a Map (for MongoDB)
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}
