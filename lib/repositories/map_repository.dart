import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:myboard/config/api_config.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/models/location_search.dart';
import 'dart:convert';
import 'package:myboard/common-util/common_util_token_interceptor.dart';

class MapRepository {
  final String _apiUrl = APIConfig.getRootURL();
  final GetIt getIt = GetIt.instance;

  Future<List<SelectLocationDTO>> searchPlaces(String query) async {
    final TokenInterceptorHttpClient tokenInterceptor =
        getIt<TokenInterceptorHttpClient>();

    final response = await tokenInterceptor.get(
      Uri.parse('$_apiUrl/google/maps/searchLocation?query=$query'),
    );

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);

      if (responseData is List) {
        // Parse the list of SelectLocationDTO directly
        List<SelectLocationDTO> placeList = responseData.map((place) {
          return SelectLocationDTO(
            name: place['name'].toString(),
            latitude: place['latitude'] as double,
            longitude: place['longitude'] as double,
          );
        }).toList();

        return placeList;
      } else {
        throw Exception('Invalid response structure');
      }
    } else {
      throw Exception(
          'Failed to search places. Status code: ${response.statusCode}');
    }
  }

  Future<List<DisplayDetails>> getDisplaysNearby(
      SelectLocationDTO locationDTO,
      ) async {
    final TokenInterceptorHttpClient tokenInterceptor =
    getIt<TokenInterceptorHttpClient>();

    final response = await tokenInterceptor.get(Uri.parse(
      '$_apiUrl/v1/displays/nearby?latitude=${locationDTO.latitude}&longitude=${locationDTO.longitude}',
    ));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => DisplayDetails.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load nearby displays');
    }
  }
}
