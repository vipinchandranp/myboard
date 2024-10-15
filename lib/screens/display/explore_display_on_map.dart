import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExploreDisplayOnMap extends StatefulWidget {
  final LatLng initialLocation;

  // Default Bangalore location
  static const LatLng bangaloreLocation = LatLng(12.9716, 77.5946);

  // Updated constructor to accept nullable initialLocation
  ExploreDisplayOnMap({LatLng? initialLocation})
      : this.initialLocation = initialLocation ?? bangaloreLocation;

  @override
  _ExploreDisplayOnMapState createState() => _ExploreDisplayOnMapState();
}

class _ExploreDisplayOnMapState extends State<ExploreDisplayOnMap> {
  late GoogleMapController _mapController;
  LatLng? _pickedLocation;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.initialLocation,
          zoom: 14,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        onTap: (LatLng location) {
          setState(() {
            _pickedLocation = location;
          });
        },
        markers: _pickedLocation != null
            ? {
                Marker(
                  markerId: MarkerId('selected-location'),
                  position: _pickedLocation!,
                ),
              }
            : {},
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.of(context).pop(_pickedLocation);
        },
      ),
    );
  }
}
