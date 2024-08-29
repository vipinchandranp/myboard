import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:myboard/config/api_config.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/models/tileslotavailability.dart';
import 'package:myboard/common-util/common_util_token_interceptor.dart';

class DisplayRepository {
  final String _apiUrl = APIConfig.getRootURL();
  final GetIt getIt = GetIt.instance;

  DisplayRepository();

  Future<List<DisplayDetails>> getAllDisplays() async {
    final TokenInterceptorHttpClient tokenInterceptor =
        getIt<TokenInterceptorHttpClient>();
    final response =
        await tokenInterceptor.get(Uri.parse('$_apiUrl/v1/displays'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => DisplayDetails.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load displays');
    }
  }

  Future<List<DisplayDetails>> getMyDisplays() async {
    final TokenInterceptorHttpClient tokenInterceptor =
        getIt<TokenInterceptorHttpClient>();
    final response =
        await tokenInterceptor.get(Uri.parse('$_apiUrl/v1/displays/user'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => DisplayDetails.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load displays');
    }
  }

  Future<List<DisplayDetails>> getDisplaysForLoggedInUser() async {
    final TokenInterceptorHttpClient tokenInterceptor =
        getIt<TokenInterceptorHttpClient>();
    final response =
        await tokenInterceptor.get(Uri.parse('$_apiUrl/v1/displays/user'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => DisplayDetails.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load displays for user');
    }
  }

  Future<Uint8List> getDisplayImage(String? displayId) async {
    final TokenInterceptorHttpClient tokenInterceptor =
        getIt<TokenInterceptorHttpClient>();
    final response = await tokenInterceptor.get(
      Uri.parse('$_apiUrl/v1/displays/image/$displayId'),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load display image');
    }
  }

  Future<List<int>> getDisplayImageQRCode() async {
    final TokenInterceptorHttpClient tokenInterceptor =
        getIt<TokenInterceptorHttpClient>();
    final response = await tokenInterceptor.get(
      Uri.parse('$_apiUrl/v1/displays/image/qr'),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load display image');
    }
  }

  Future<TimeSlotAvailability> getDisplayTimeSlots(
      String displayId, DateTime date) async {
    final TokenInterceptorHttpClient tokenInterceptor =
        getIt<TokenInterceptorHttpClient>();

    // Build the URL with query parameters
    final Uri uri = Uri.parse(
        '$_apiUrl/v1/displays/timeslots?displayId=$displayId&date=${date.toIso8601String()}');

    final response = await tokenInterceptor.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> timeslots = json.decode(response.body);
      return TimeSlotAvailability.fromJson(timeslots);
    } else {
      throw Exception('Failed to load display timeslots');
    }
  }

Future<List<DisplayDetails>> getNearbyDisplays() async {
  final TokenInterceptorHttpClient tokenInterceptor =
      getIt<TokenInterceptorHttpClient>();

  // Build the URL with query parameters
  final Uri uri = Uri.parse('$_apiUrl/v1/displays/nearby');

  final response = await tokenInterceptor.get(uri);

  if (response.statusCode == 200) {
    final List<dynamic> displays = json.decode(response.body);
    return displays.map((display) => DisplayDetails.fromJson(display)).toList();
  } else {
    throw Exception('Failed to load nearby displays');
  }
}
}
