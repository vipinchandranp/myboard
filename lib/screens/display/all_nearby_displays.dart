import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/repositories/display_repository.dart';

class AllNearbyDisplaysMapScreen extends StatefulWidget {
  @override
  _AllNearbyDisplaysMapScreenState createState() => _AllNearbyDisplaysMapScreenState();
}

class _AllNearbyDisplaysMapScreenState extends State<AllNearbyDisplaysMapScreen> {
  final DisplayRepository _displayRepository = DisplayRepository();
  List<DisplayDetails> _nearbyDisplays = [];

  @override
  void initState() {
    super.initState();
    _fetchNearbyDisplays();
  }

  Future<void> _fetchNearbyDisplays() async {
    try {
      final displays = await _displayRepository.getNearbyDisplays();
      setState(() {
        _nearbyDisplays = displays;
      });
    } catch (e) {
      print('Failed to fetch nearby displays: $e');
    }
  }

@override
Widget build(BuildContext context) {
  return _nearbyDisplays.isEmpty
      ? Center(child: CircularProgressIndicator())
      : GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(0, 0), // Set this to the user's current location
            zoom: 14,
          ),
          markers: _nearbyDisplays.map((display) {
            return Marker(
              markerId: MarkerId(display.id!),
              position: LatLng(display.latitude!, display.longitude!),
              infoWindow: InfoWindow(
                title: display.id,
                snippet: display.description,
              ),
            );
          }).toSet(),
        );
}
}