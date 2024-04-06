import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:myboard/common-util/common_util_token_interceptor.dart';
import 'package:myboard/config/api_config.dart';
import 'package:myboard/models/route.dart';

class RouteRepository {
  final String _apiUrl = APIConfig.getRootURL();
  final GetIt getIt = GetIt.instance;

  Future<void> saveRoute(BuildContext context, RouteModel route) async {
    final TokenInterceptorHttpClient tokenInterceptor =
        getIt<TokenInterceptorHttpClient>();
    try {
      final response = await tokenInterceptor.post(
        Uri.parse('$_apiUrl/v1/route/save'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(route.toJson()),
      );

      if (response.statusCode == 201) {
        // Route saved successfully
        print('Route saved successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Route saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Handle error case
        print('Failed to save route: ${response.statusCode}');
        throw Exception('Failed to save route');
      }
    } catch (e) {
      // Handle exception
      print('Exception while saving route: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save route'),
          duration: Duration(seconds: 2),
        ),
      );
      throw Exception('Failed to save route');
    }
  }

  Future<List<RouteModel>> getAllRoutes() async {
    final TokenInterceptorHttpClient tokenInterceptor =
        getIt<TokenInterceptorHttpClient>();
    try {
      final response = await tokenInterceptor.get(
        Uri.parse('$_apiUrl/v1/route/allroutes'),
      );

      if (response.statusCode == 200) {
        // Routes fetched successfully
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((json) => RouteModel.fromJson(json)).toList();
      } else {
        // Handle error case
        print('Failed to fetch routes: ${response.statusCode}');
        throw Exception('Failed to fetch routes');
      }
    } catch (e) {
      // Handle exception
      print('Exception while fetching routes: $e');
      throw Exception('Failed to fetch routes');
    }
  }

  Future<RouteModel> getRouteById(String routeId) async {
    final TokenInterceptorHttpClient tokenInterceptor =
        getIt<TokenInterceptorHttpClient>();
    try {
      final response = await tokenInterceptor.get(
        Uri.parse('$_apiUrl/v1/route/$routeId'),
      );

      if (response.statusCode == 200) {
        // Route fetched successfully
        return RouteModel.fromJson(json.decode(response.body));
      } else {
        // Handle error case
        print('Failed to fetch route: ${response.statusCode}');
        throw Exception('Failed to fetch route');
      }
    } catch (e) {
      // Handle exception
      print('Exception while fetching route: $e');
      throw Exception('Failed to fetch route');
    }
  }

  Future<void> updateRoute(BuildContext context, RouteModel route) async {
    final TokenInterceptorHttpClient tokenInterceptor =
        getIt<TokenInterceptorHttpClient>();
    try {
      final response = await tokenInterceptor.put(
        Uri.parse('$_apiUrl/v1/route/${route.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(route.toJson()),
      );

      if (response.statusCode == 200) {
        // Route updated successfully
        print('Route updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Route updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Handle error case
        print('Failed to update route: ${response.statusCode}');
        throw Exception('Failed to update route');
      }
    } catch (e) {
      // Handle exception
      print('Exception while updating route: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update route'),
          duration: Duration(seconds: 2),
        ),
      );
      throw Exception('Failed to update route');
    }
  }

  Future<void> deleteRoute(BuildContext context, String routeId) async {
    final TokenInterceptorHttpClient tokenInterceptor =
        getIt<TokenInterceptorHttpClient>();
    try {
      final response = await tokenInterceptor.delete(
        Uri.parse('$_apiUrl/v1/route/$routeId'),
      );

      if (response.statusCode == 200) {
        // Route deleted successfully
        print('Route deleted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Route deleted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Handle error case
        print('Failed to delete route: ${response.statusCode}');
        throw Exception('Failed to delete route');
      }
    } catch (e) {
      // Handle exception
      print('Exception while deleting route: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete route'),
          duration: Duration(seconds: 2),
        ),
      );
      throw Exception('Failed to delete route');
    }
  }
}
