import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/models/interceptor_contract.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpInterceptor implements InterceptorContract {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final void Function(String, String) showSnackBar;

  HttpInterceptor({required this.showSnackBar});

  @override
  FutureOr<bool> shouldInterceptRequest() => true;

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    String? token = await _storage.read(key: 'jwtToken');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    print('Request: ${request.method} ${request.url}');
    print('Headers: ${request.headers}');
    if (request is Request) {
      print('Body: ${request.body}');
    }

    return request;
  }

  @override
  FutureOr<bool> shouldInterceptResponse() => false;

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    print('Response: ${response.statusCode} ${response.request?.url}');
    print('Headers: ${response.headers}');

    // Process the response if necessary
    return response;
  }
}
