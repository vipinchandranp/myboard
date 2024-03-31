import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TokenInterceptorHttpClient implements http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.Response> delete(Uri url,
      {Object? body, Encoding? encoding, Map<String, String>? headers}) async {
    final authorizedHeaders = await _addAuthorizationHeader(headers);
    return _inner.delete(url,
        body: body, encoding: encoding, headers: authorizedHeaders);
  }

  @override
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final authorizedHeaders = await _addAuthorizationHeader(headers);
    return _inner.patch(url,
        headers: authorizedHeaders, body: body, encoding: encoding);
  }

  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final authorizedHeaders = await _addAuthorizationHeader(headers);
    return _inner.put(url,
        headers: authorizedHeaders, body: body, encoding: encoding);
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) async {
    final response = await get(url, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
          'Failed to read data. Status code: ${response.statusCode}');
    }
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) async {
    final response = await get(url, headers: headers);
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception(
          'Failed to read bytes. Status code: ${response.statusCode}');
    }
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) {
    return _inner.head(url, headers: headers);
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final authorizedHeaders = await _addAuthorizationHeader(headers);
    return _inner.get(url, headers: authorizedHeaders);
  }

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final authorizedHeaders = await _addAuthorizationHeader(headers);
    return _inner.post(url,
        headers: authorizedHeaders, body: body, encoding: encoding);
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final authorizedHeaders =
        await _addAuthorizationHeader(request.headers, baseRequest: request);
    return _inner.send(request); // Pass the original request to _inner.send
  }

  @override
  void close() {
    _inner.close();
  }

  Future<Map<String, String>?> _addAuthorizationHeader(
      Map<String, String>? headers,
      {http.BaseRequest? baseRequest}) async {
    headers = Map.from(headers ?? <String, String>{});

    String? token = await _getToken();

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (baseRequest != null) {
      baseRequest.headers.addAll(headers);
      return baseRequest.headers as Map<String, String>;
    }

    return headers;
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
