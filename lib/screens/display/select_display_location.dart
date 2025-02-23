import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class SelectLocationWidget extends StatefulWidget {
  final LatLng initialLocation;

  const SelectLocationWidget({Key? key, required this.initialLocation})
      : super(key: key);

  @override
  _SelectLocationWidgetState createState() => _SelectLocationWidgetState();
}

class _SelectLocationWidgetState extends State<SelectLocationWidget> {
  late GoogleMapController _mapController;
  late LatLng _currentLocation;
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.initialLocation;
    _fetchAddress(_currentLocation);
  }

  Future<void> _fetchAddress(LatLng location) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(location.latitude, location.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _currentAddress =
          "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'Address not found';
      });
    }
  }

  void _onCameraMove(CameraPosition position) {
    _currentLocation = position.target;
  }

  void _onCameraIdle() {
    _fetchAddress(_currentLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
            CameraPosition(target: widget.initialLocation, zoom: 14),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
          ),
          // Display the current address while moving the map
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _currentAddress ?? "Fetching address...",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          // Center location marker icon overlay
          Center(
            child: Icon(
              Icons.location_on,
              size: 40,
              color: Colors.red,
            ),
          ),
          // Button to confirm the selection
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _currentLocation);
              },
              child: Text('Select this location'),
            ),
          ),
        ],
      ),
    );
  }
}
