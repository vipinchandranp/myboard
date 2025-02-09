import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationWidget extends StatefulWidget {
  final LatLng initialLocation;

  SelectLocationWidget({required this.initialLocation});

  @override
  _SelectLocationWidgetState createState() => _SelectLocationWidgetState();
}

class _SelectLocationWidgetState extends State<SelectLocationWidget> {
  LatLng _currentLocation = LatLng(12.9716, 77.5946); // Default to Bangalore
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.initialLocation;
  }

  void _onMapMoved(CameraPosition position) {
    setState(() {
      _currentLocation = position.target;
    });
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _currentLocation = position;
    });
    _mapController?.animateCamera(CameraUpdate.newLatLng(position));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation,
          zoom: 12,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        onCameraMove: _onMapMoved,
        onTap: _onMapTapped,
        markers: {
          Marker(
            markerId: MarkerId('current-location'),
            position: _currentLocation,
          ),
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context, _currentLocation);
        },
        label: Text('Select'),
        icon: Icon(Icons.check),
      ),
    );
  }
}