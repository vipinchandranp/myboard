import 'package:flutter/material.dart';
import '../../api_models/user_cities_response.dart';
import '../../api_models/user_details_request.dart';
import '../../repository/user_repository.dart';
import 'view_cities_widget.dart';

class UserLocationWidget extends StatefulWidget {
  @override
  _UserLocationWidgetState createState() => _UserLocationWidgetState();
}

class _UserLocationWidgetState extends State<UserLocationWidget> {
  String? _userCity;
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadUserCity();
  }

  Future<void> _loadUserCity() async {
    try {
      UserService userService = UserService(context);
      _userCity = await userService.getUserCity();
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _selectCity(BuildContext context) async {
    final CitiesResponse? selectedCity = await showDialog<CitiesResponse>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ViewCitiesWidget(), // Show the CitySectionsWidget
        );
      },
    );

    if (selectedCity != null) {
      setState(() {
        _userCity = selectedCity.cityName; // Update the user city
      });

      // Save the selected city to the user repository
      await _updateUserCity(selectedCity.cityName);
    }
  }

  Future<void> _updateUserCity(String cityName) async {
    try {
      UserService userService = UserService(context);
      // Get current user details (assume you have a method to re
      // Create an updated UserDetailsRequest
      UserDetailsRequest updatedUserDetails = UserDetailsRequest(
        cityName: cityName, // Set the new city name
      );

      // Update user details
      await userService.updateUserDetails(updatedUserDetails);
    } catch (e) {
      print('Failed to update user city: $e'); // Handle errors accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return CircularProgressIndicator(); // Show loading indicator
    }

    if (_error.isNotEmpty) {
      return Text('Error: $_error'); // Show error message
    }

    return GestureDetector(
      onTap: () => _selectCity(context), // Open city selection dialog
      child: Text(_userCity ?? 'No city selected'), // Display user city
    );
  }
}
