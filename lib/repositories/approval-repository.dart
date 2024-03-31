import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:myboard/config/api_config.dart';
import 'package:myboard/models/ApprovalIncomingRequest.dart';
import 'package:get_it/get_it.dart';
import 'package:myboard/common-util/common_util_token_interceptor.dart';
import 'package:myboard/models/ApprovalOutgoingRequest.dart';

class ApprovalRepository {
  final String _apiUrl = APIConfig.getRootURL();
  final GetIt getIt = GetIt.instance;

  Future<List<ApprovalIncomingRequest>> getIncomingApprovalList() async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
          getIt<TokenInterceptorHttpClient>();

      final response = await tokenInterceptor.get(
        Uri.parse('$_apiUrl/v1/approval/incoming/display-time-slots'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        final displayTimeSlots = data
            .map((item) => ApprovalIncomingRequest.fromJson(item))
            .toList()
            .cast<ApprovalIncomingRequest>();
        return displayTimeSlots;
      } else {
        // Handle error case
        throw Exception('Failed to fetch display time slots');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to fetch display time slots');
    }
  }

  Future<List<ApprovalOutgoingRequest>> getOutgoingApprovalList() async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
      getIt<TokenInterceptorHttpClient>();

      final response = await tokenInterceptor.get(
        Uri.parse('$_apiUrl/v1/approval/outgoing/display-time-slots'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        final displayTimeSlots = data
            .map((item) => ApprovalOutgoingRequest.fromJson(item))
            .toList()
            .cast<ApprovalOutgoingRequest>();
        return displayTimeSlots;
      } else {
        // Handle error case
        throw Exception('Failed to fetch display time slots');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to fetch display time slots');
    }
  }

  Future<void> approveRequest(String requestId) async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
          getIt<TokenInterceptorHttpClient>();

      final response = await tokenInterceptor.put(
        Uri.parse('$_apiUrl/v1/approval/approve-display-time-slot/approve/$requestId'),
        // You might need to send additional data in the request body if required
      );

      if (response.statusCode == 200) {
        // Request approved successfully
      } else {
        // Handle error case
        throw Exception('Failed to approve request');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to approve request');
    }
  }

  Future<void> rejectRequest(String requestId) async {
    try {
      final TokenInterceptorHttpClient tokenInterceptor =
      getIt<TokenInterceptorHttpClient>();

      final response = await tokenInterceptor.put(
        Uri.parse('$_apiUrl/v1/approval/approve-display-time-slot/reject/$requestId'),
        // You might need to send additional data in the request body if required
      );

      if (response.statusCode == 200) {
        // Request rejected successfully
      } else {
        // Handle error case
        throw Exception('Failed to reject request');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to reject request');
    }
  }

  Future<Uint8List?> getBoardImage(String boardId) async {
    final TokenInterceptorHttpClient tokenInterceptor =
        getIt<TokenInterceptorHttpClient>();
    try {
      final response = await tokenInterceptor.get(
        Uri.parse('$_apiUrl/v1/board/details/$boardId'),
      );

      if (response.statusCode == 200) {
        // Image data received successfully
        return response.bodyBytes;
      } else {
        // Error handling
        print('Failed to fetch board image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Exception handling
      print('Exception while fetching board image: $e');
      return null;
    }
  }
}
