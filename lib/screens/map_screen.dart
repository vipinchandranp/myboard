import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myboard/bloc/map/map_cubit.dart';
import 'package:myboard/bloc/map/map_state.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/models/location_search.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/repositories/user_repository.dart';
import 'package:myboard/repositories/map_repository.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapCubit mapCubit;
  Set<Marker> markers = {};
  Completer<GoogleMapController> _controllerCompleter = Completer();
  Completer<void> _loadNearbyDisplaysCompleter = Completer<void>();
  TextEditingController _locationController = TextEditingController();
  final Key _mapKey = UniqueKey();

  final MapRepository mapRepository = MapRepository();
  SelectLocationDTO? _selectedLocation; // Initialize as null

  @override
  void initState() {
    super.initState();
    mapCubit = BlocProvider.of<MapCubit>(context);

    // Initialize _selectedLocation as null
    _selectedLocation = null;

    // Load the initial map using UserRepository
    _loadUserLocation();

    // Listen to state changes and update the map
    mapCubit.stream.listen((state) {
      if (state is SelectedLocation) {
        _selectedLocation = state.selectedLocation;
        _loadMap(_selectedLocation!); // Use non-null assertion
        _loadNearbyDisplays(_selectedLocation!); // Use non-null assertion
      }
    });
  }

  Future<void> _loadUserLocation() async {
    try {
      MyBoardUser? user = await UserRepository().initUser();

      if (user != null && user.location != null) {
        _selectedLocation = SelectLocationDTO(
          latitude: user.location!.latitude,
          longitude: user.location!.longitude,
          name: user.location!.name,
        );
        _locationController.text = _selectedLocation!.name;
        _loadMap(_selectedLocation!);
        _loadNearbyDisplays(_selectedLocation!);
      } else {
        print('User or user location is null');
      }
    } catch (e) {
      print('Error loading user location: $e');
    }
  }

  void _loadMap(SelectLocationDTO location) {
    // Trigger a rebuild by changing the key
    _mapKey;
    _controllerCompleter.future.then((controller) {
      _animateToSelectedLocation(controller, location);
    });
  }

  void _loadNearbyDisplays(SelectLocationDTO location) async {
    try {
      // Fetch nearby displays using MapRepository
      final List<DisplayDetails> nearbyDisplays =
          await mapRepository.getDisplaysNearby(location);

      // Clear existing markers
      markers.clear();

      // Add markers for each nearby display
      for (DisplayDetails display in nearbyDisplays) {
        if (display.latitude != null && display.longitude != null) {
          print(
              'Adding marker for $display at ${display.latitude}, ${display.longitude}');
          markers.add(
            Marker(
              markerId: MarkerId(display.id),
              position: LatLng(
                display.latitude!,
                display.longitude!,
              ),
              infoWindow: InfoWindow(
                title: display.displayName,
                snippet: display.description ?? '',
              ),
            ),
          );
        }
      }

      // Print the list of nearby displays
      print('Nearby Displays: $nearbyDisplays');

      // Update the state to rebuild the widget
      setState(() {});
    } catch (e) {
      print('Error loading nearby displays: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            key: _mapKey,
            onMapCreated: (controller) async {
              _controllerCompleter.complete(controller);

              // Wait for _loadNearbyDisplaysCompleter to complete before updating markers
              await _loadNearbyDisplaysCompleter.future;
              _loadMap(_selectedLocation!);
            },
            initialCameraPosition: _selectedLocation != null
                ? CameraPosition(
                    target: LatLng(
                      _selectedLocation!.latitude,
                      _selectedLocation!.longitude,
                    ),
                    zoom: 15.0,
                  )
                : CameraPosition(
                    target: LatLng(0, 0),
                    zoom: 15.0,
                  ),
            markers: markers, // Set the markers on the map
          ),
        ],
      ),
    );
  }

  // Add this method to animate the map to the selected location
  void _animateToSelectedLocation(
    GoogleMapController controller,
    SelectLocationDTO selectedLocation,
  ) {
    controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          selectedLocation.latitude,
          selectedLocation.longitude,
        ),
      ),
    );
  }
}
