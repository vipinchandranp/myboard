import 'dart:async';
import 'dart:ui';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myboard/bloc/map/map_cubit.dart';
import 'package:myboard/bloc/map/map_state.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/models/location_search.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/repositories/map_repository.dart';
import 'package:myboard/repositories/user_repository.dart';

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
  SelectLocationDTO? _selectedLocation;

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
        setState(() {
          _selectedLocation = state.selectedLocation;
          _loadMap(_selectedLocation!); // Use non-null assertion
          _loadNearbyDisplays(_selectedLocation!); // Use non-null assertion
        });
      }
    });
  }

  Future<Uint8List> getBytesFromAsset(
    String path,
    int width,
    int height,
  ) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(
      // Use convert.Codec
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
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
    ByteData byteData = await rootBundle.load('assets/display-map-marker.png');
    Uint8List imageData = byteData.buffer.asUint8List();
    try {
      // Fetch nearby displays using MapRepository
      final List<DisplayDetails> nearbyDisplays =
          await mapRepository.getDisplaysNearby(location);

      // Clear existing markers
      markers.clear();

      // Add markers for each nearby display
      for (DisplayDetails display in nearbyDisplays) {
        if (display.latitude != null && display.longitude != null) {
          markers.add(
            Marker(
              markerId: MarkerId(display.id),
              position: LatLng(
                display.latitude!,
                display.longitude!,
              ),
              icon: BitmapDescriptor.fromBytes(imageData),
              infoWindow: InfoWindow(
                title: display.displayName,
                snippet: display.description ?? '',
              ),
            ),
          );
        }
      }

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
              await _loadNearbyDisplaysCompleter.future;
              _setInitialCameraPosition(controller);
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
            markers: markers,
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

  void _setInitialCameraPosition(GoogleMapController controller) {
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _selectedLocation!.latitude,
            _selectedLocation!.longitude,
          ),
          zoom: 15.0,
        ),
      ),
    );
  }
}
