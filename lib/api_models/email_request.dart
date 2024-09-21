class EmailRequest {
  final String to;
  final String subject;
  final String body;

  EmailRequest({
    required this.to,
    required this.subject,
    required this.body,
  });

  Map<String, dynamic> toJson() {
    return {
      'to': to,
      'subject': subject,
      'body': body,
    };
  }
}
