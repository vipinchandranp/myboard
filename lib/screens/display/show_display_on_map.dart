import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myboard/models/display/bdisplay.dart';

class ShowDisplayOnMap extends StatelessWidget {
  final BDisplay display;

  const ShowDisplayOnMap({
    Key? key,
    required this.display,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if the latitude and longitude are provided
    if (display.latitude == null || display.longitude == null) {
      return Center(
        child: Text(
          'Location not available for this display.',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    // Create a LatLng object from the display's latitude and longitude
    final LatLng displayLocation = LatLng(display.latitude!, display.longitude!);

    return Scaffold(
      appBar: AppBar(
        title: Text('Location of ${display.displayName}'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: displayLocation,
          zoom: 15.0, // Set the initial zoom level
        ),
        markers: {
          Marker(
            markerId: MarkerId(display.displayId),
            position: displayLocation,
            infoWindow: InfoWindow(
              title: display.displayName,
              snippet: 'Status: ${display.status}',
            ),
          ),
        },
        // You can also add other Google Maps options here if needed
      ),
    );
  }
}
