import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:myboard/config/api_config.dart';
import 'dart:convert';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/models/location_search.dart';
import 'package:myboard/utils/token_interceptor.dart';

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

  Future<List<int>> getDisplayImage(String? displayId) async {
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

}
