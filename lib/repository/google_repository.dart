import 'dart:convert';
import 'package:flutter/material.dart';
import '../api_models/user_cities_response.dart';
import '../repository/base_repository.dart';

class GoogleService extends BaseRepository {
  GoogleService(BuildContext context) : super(context);

  /// Fetch cities from the `/cities` endpoint based on the query parameter
  Future<List<CitiesResponse>> getCities(String query) async {
    final response = await client.get(
      Uri.parse('$apiUrl/map/cities?query=$query'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success' && data['data'] is List) {
        return (data['data'] as List)
            .map((json) => CitiesResponse.fromJson(json))
            .toList();
      } else {
        throw Exception('Unexpected response structure: ${data['status']}');
      }
    } else {
      throw Exception('Failed to fetch cities: ${response.statusCode}');
    }
  }
}
