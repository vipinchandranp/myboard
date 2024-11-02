import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/display/bdisplay.dart';
import '../../repository/display_repository.dart';
import '../../repository/user_repository.dart';
import '../../screens/display/display_card.dart'; // Import the DisplayCardWidget

class NearbyDisplaysMap extends StatefulWidget {
  @override
  _NearbyDisplaysMapState createState() => _NearbyDisplaysMapState();
}

class _NearbyDisplaysMapState extends State<NearbyDisplaysMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  List<BDisplay> _nearbyDisplays = [];
  LatLng? _userLocation; // Variable to hold user location

  @override
  void initState() {
    super.initState();
    _fetchUserLocationAndNearbyDisplays();
  }

  // Fetch user location and nearby displays, then update the map
  Future<void> _fetchUserLocationAndNearbyDisplays() async {
    UserService userService = UserService(context);

    try {
      // Fetch user location
      Map<String, double> userLocation = await userService.getUserLocation();
      print('Fetched user location: $userLocation'); // Debug print

      setState(() {
        _userLocation = LatLng(userLocation['latitude']!, userLocation['longitude']!);
      });

      // Fetch nearby displays
      DisplayService displayService = DisplayService(context);
      List<BDisplay>? nearbyDisplays = await displayService.getAllDisplays();

      if (nearbyDisplays != null) {
        setState(() {
          _nearbyDisplays = nearbyDisplays;
          _addMarkers();
        });
      } else {
        print('Failed to load nearby displays');
      }
    } catch (e) {
      print('Error fetching user location or nearby displays: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load nearby displays.')),
      );
    }
  }

  // Add markers for each display
  void _addMarkers() {
    Set<Marker> newMarkers = _nearbyDisplays.map((display) {
      return Marker(
        markerId: MarkerId(display.displayId),
        position: LatLng(display.latitude!, display.longitude!),
        infoWindow: InfoWindow(
          title: display.displayName,
          snippet: 'ID: ${display.displayId}',
        ),
        // Add onTap functionality to open the DisplayCardWidget
        onTap: () {
          _showDisplayDetails(display.displayId); // Pass the display ID
        },
      );
    }).toSet();

    setState(() {
      _markers = newMarkers;
    });
  }

  // Function to navigate to the DisplayCardWidget in a bottom sheet
  Future<void> _showDisplayDetails(String displayId) async {
    DisplayService displayService = DisplayService(context);

    // Fetch the display details using the display ID
    BDisplay? display = await displayService.getDisplayById(displayId);

    if (display != null) {
      // Show bottom sheet with DisplayCardWidget
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Allow for scrolling if needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Curved edges
        ),
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75, // Set height for the bottom sheet
            child: DisplayCardWidget(display: display), // Pass the display to the DisplayCardWidget
          );
        },
      );
    } else {
      // Handle the case when display details could not be fetched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load display details.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Displays'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _userLocation != null
            ? CameraPosition(
          target: _userLocation!,
          zoom: 14, // Zoom in closer to the user's location
        )
            : CameraPosition(
          target: LatLng(8.7832, 80.7795), // Fallback position
          zoom: 4, // Adjust zoom level
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
