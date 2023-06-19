import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TokenInterceptor extends http.BaseClient {
  final String token;
  final http.Client _httpClient;

  TokenInterceptor(this.token) : _httpClient = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    // Set the Authorization header with the token
    request.headers['Authorization'] = 'Bearer $token';
    return _httpClient.send(request);
  }

  // Implement the missing methods
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return _httpClient.get(url, headers: headers);
  }

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _httpClient.post(url, headers: headers, body: body, encoding: encoding);
  }

  // Implement other methods such as delete, put, etc.

  @override
  void close() {
    _httpClient.close();
  }
}
