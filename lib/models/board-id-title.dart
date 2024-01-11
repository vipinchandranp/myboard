class BoardIdTitle {
  final String id;
  final String userId;
  final String title;

  BoardIdTitle({
    required this.id,
    required this.userId,
    required this.title,
  });

  factory BoardIdTitle.fromJson(Map<String, dynamic> json) {
    return BoardIdTitle(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
    );
  }
}
