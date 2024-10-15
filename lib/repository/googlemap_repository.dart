import 'dart:convert';
import 'package:flutter/material.dart';
import '../api_models/user_cities_response.dart';
import 'base_repository.dart';
class GoogleMapService extends BaseRepository {
  GoogleMapService(BuildContext context) : super(context);

  Future<List<CitiesResponse>?> getCities() async {
    try {
      final response = await client.get(
        Uri.parse('$apiUrl/map/cities'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> citiesData = json.decode(response.body)['data'];
        return citiesData.map<CitiesResponse>((json) => CitiesResponse.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      print('Error fetching cities: $e');
      return null;
    }
  }
}
