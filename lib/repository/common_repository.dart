import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/common/AbstractFilterResponse.dart';
import '../models/common/AbstractFilterRequest.dart';
import 'base_repository.dart';

/// A service for interacting with common API endpoints.
class CommonService extends BaseRepository {
  CommonService(BuildContext context) : super(context);

  /// Fetches a list of common items based on filter criteria.
  Future<List<AbstractFilterResponse>?> searchCommonItems(
      AbstractFilterRequest filterRequest) async {
    try {
      // Convert filter request to JSON
      final Map<String, dynamic> requestBody = filterRequest.toJson();

      // Construct URL
      final url = Uri.parse('$apiUrl/common/search/list');

      // Make the POST request
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic> dataList = responseBody['data'];

        // Map JSON data to AbstractFilterResponse objects
        return dataList
            .map((json) => AbstractFilterResponse.fromJson(json))
            .toList();
      } else {
        handleError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching common items: $e');
      return null;
    }
  }
}
