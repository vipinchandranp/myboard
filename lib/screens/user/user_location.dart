import 'package:flutter/material.dart';
import '../../api_models/user_cities_response.dart';
import '../../api_models/user_details_request.dart';
import '../../repository/user_repository.dart';
import 'view_cities_widget.dart';
import 'package:myboard/widgets/profile_pic_widget.dart'; // Import the ProfilePictureWidget

class UserLocationWidget extends StatefulWidget {
  @override
  _UserLocationWidgetState createState() => _UserLocationWidgetState();
}

class _UserLocationWidgetState extends State<UserLocationWidget> {
  String? _userCity;
  double? _latitude;
  double? _longitude;
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    try {
      UserService userService = UserService(context);

      // Load city and location using UserDetailsRequest
      UserDetailsRequest locationData = await userService.getUserLocation();
      setState(() {
        _userCity = locationData.cityName;
        _latitude = locationData.latitude;
        _longitude = locationData.longitude;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
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
          child: ViewCitiesWidget(), // Show the ViewCitiesWidget
        );
      },
    );

    if (selectedCity != null) {
      try {
        // Update the user city and location in the widget state
        setState(() {
          _userCity = selectedCity.cityName;
          _latitude = selectedCity.latitude;
          _longitude = selectedCity.longitude;
        });

        // Save the updated city and location to the backend
        await _updateUserCityAndLocation();
      } catch (e) {
        print('Error updating user city and location: $e');
      }
    }
  }

  Future<void> _updateUserCityAndLocation() async {
    try {
      UserService userService = UserService(context);

      // Create updated UserDetailsRequest with city and location
      UserDetailsRequest updatedUserDetails = UserDetailsRequest(
        cityName: _userCity,
        latitude: _latitude,
        longitude: _longitude,
      );

      // Save updated details to backend
      await userService.saveOrUpdateUserDetails(updatedUserDetails);
    } catch (e) {
      print('Failed to update user city and location: $e'); // Handle errors accordingly
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: Colors.grey),
          color: Colors.white,
        ),
        child: Row(
          children: [
            // Profile picture on the left side with reduced size
            Container(
              margin: EdgeInsets.only(right: 8.0), // Spacing between profile picture and text
              child: ClipOval(
                child: SizedBox(
                  height: 30, // Set the height to make it small
                  width: 30, // Set the width to make it small
                  child: ProfilePictureWidget(isEditable: false), // Adjust size as needed
                ),
              ),
            ),
            Expanded(
              child: Text(
                _userCity ?? 'Select a city',
                style: TextStyle(color: Colors.black),
              ),
            ),
            // Use the asset image for location icon
            Image.asset(
              'assets/userlocation.png',
              height: 24,
              width: 24,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
