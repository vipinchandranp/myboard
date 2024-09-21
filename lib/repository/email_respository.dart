import 'dart:convert';
import 'package:myboard/repository/base_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api_models/email_request.dart';

class EmailRepository extends BaseRepository {
  // Create a secure storage instance
  final _storage = const FlutterSecureStorage();

  EmailRepository(super.context);

  Future<void> sendEmail(EmailRequest emailRequest) async {
    final response = await client.post(
      Uri.parse('$apiUrl/email/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(emailRequest.toJson()),
    );

    if (response.statusCode == 200) {
      print('Email sent successfully');
    } else {
      print('Failed to send email: ${response.statusCode} ${response.body}');
      throw Exception('Failed to send email');
    }
  }
}
