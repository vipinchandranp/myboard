import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../api_models/user_details_request.dart';
import '../../models/display/bdisplay.dart';
import '../../repository/display_repository.dart';
import '../../repository/user_repository.dart';
import '../../screens/display/display_card.dart';
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
      // Fetch user location as a UserDetailsRequest object
      UserDetailsRequest userLocation = await userService.getUserLocation();
      print('Fetched user location: $userLocation'); // Debug print

      setState(() {
        _userLocation = LatLng(userLocation.latitude!, userLocation.longitude!);
      });

      // Fetch nearby displays
      DisplayService displayService = DisplayService(context);
      List<BDisplay>? nearbyDisplays = await displayService.getNearbyDisplays();

      if (nearbyDisplays != null) {
        setState(() {
          _nearbyDisplays = nearbyDisplays;
          _addMarkers();
        });
      } else {
        print('Failed to load nearby displays');
      }

      // Move the camera to the user's location
      if (_userLocation != null) {
        final GoogleMapController mapController = await _controller.future;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _userLocation!, zoom: 14),
          ),
        );
      }
    } catch (e) {
      print('Error fetching user location or nearby displays: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load nearby displays.')),
      );
    }
  }

  Future<BitmapDescriptor> _createCustomMarkerIcon(
      String assetPath, int width) async {
    try {
      // Load the image from the asset
      final ByteData data = await rootBundle.load(assetPath);
      final ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: width, // Adjust the width for scaling
      );
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      // Convert the image to a byte array
      final Uint8List byteData =
      (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!
          .buffer
          .asUint8List();

      return BitmapDescriptor.fromBytes(byteData);
    } catch (e) {
      print('Error creating custom marker icon: $e');
      return BitmapDescriptor.defaultMarker; // Fallback to default marker
    }
  }

  Future<void> _addMarkers() async {
    try {
      // Create the custom marker icon
      final BitmapDescriptor customIcon =
      await _createCustomMarkerIcon('assets/pin-location.png', 120);

      // Animate and add each marker
      for (var display in _nearbyDisplays) {
        final marker = Marker(
          markerId: MarkerId(display.displayId),
          position: LatLng(display.latitude!, display.longitude!),
          icon: customIcon,
          infoWindow: InfoWindow(
            title: display.displayName,
            snippet: 'ID: ${display.displayId}',
          ),
          onTap: () {
            _showDisplayDetails(display.displayId);
          },
        );

        // Animate the marker addition
        await _animateMarker(marker);
      }
    } catch (e) {
      print('Error adding markers: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add markers to the map.')),
      );
    }
  }

  Future<void> _animateMarker(Marker marker) async {
    Set<Marker> animatedMarkers = {..._markers};
    animatedMarkers.removeWhere((m) => m.markerId == marker.markerId);

    // Temporarily remove the marker and re-add it with animation delay
    setState(() {
      _markers = animatedMarkers;
    });

    await Future.delayed(const Duration(milliseconds: 200)); // Animation delay

    setState(() {
      _markers.add(marker);
    });
  }

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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8, // Limit height
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DisplayCardWidget(
                  display: display,
                ),
              ),
            ),
          );
        },
      );
    } else {
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
        initialCameraPosition: CameraPosition(
          target: _userLocation ?? LatLng(8.7832, 80.7795),
          zoom: _userLocation != null ? 14 : 4,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
