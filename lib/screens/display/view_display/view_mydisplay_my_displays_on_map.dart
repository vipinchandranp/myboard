  import 'dart:async';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:google_maps_flutter/google_maps_flutter.dart';
  import 'package:myboard/bloc/display/display_cubit.dart';
  import 'package:myboard/bloc/map/map_cubit.dart';
  import 'package:myboard/bloc/map/map_state.dart';
  import 'package:myboard/models/display_details.dart';
  import 'package:myboard/models/location_search.dart';
  import 'package:myboard/models/user.dart';
  import 'package:myboard/repositories/display_repository.dart';
  import 'package:myboard/repositories/user_repository.dart';

  class MyDisplaysOnMapScreen extends StatefulWidget {
    @override
    _MyDisplaysOnMapScreenState createState() => _MyDisplaysOnMapScreenState();
  }

  class _MyDisplaysOnMapScreenState extends State<MyDisplaysOnMapScreen> {
    late TextEditingController descriptionController;
    late TextEditingController nameController;
    Set<Marker> _markers = {}; // Initialize as empty set
    SelectLocationDTO? _selectedLocation;
    Key _mapKey = UniqueKey();

    bool isLoading = true;
    late MapCubit mapCubit;
    late DisplayCubit displayCubit;
    Completer<GoogleMapController> _controllerCompleter = Completer();
    bool isUserLocationLoaded = false;

    // Custom marker icons
    BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
    BitmapDescriptor selectedMarkerIcon = BitmapDescriptor.defaultMarker;

    @override
    void initState() {
      super.initState();
      descriptionController = TextEditingController();
      nameController = TextEditingController();
      mapCubit = BlocProvider.of<MapCubit>(context);
      displayCubit = BlocProvider.of<DisplayCubit>(context);

      // Load user's initial location only if it's not already loaded
      if (!isUserLocationLoaded) {
        _loadUserLocation();
      }

      mapCubit.stream.listen((state) {
        if (state is SelectedLocation) {
          _updateSelectedLocation(state);
        }
      });

      _loadUserDisplays(); // Load displays for the logged-in user

      // Load custom marker icons
      _loadCustomMarkerIcons();
    }

    @override
    void dispose() {
      descriptionController.dispose();
      nameController.dispose();
      super.dispose();
    }

    void _updateSelectedLocation(SelectedLocation state) {
      setState(() {
        _selectedLocation = state.selectedLocation;
        _mapKey = UniqueKey(); // Update the key
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Row(
          children: [
            Expanded(
              child: _buildMap(),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topCenter, // Updated alignment
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
                    // Adjusted padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Pin a location and upload photo of your display',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show user's current location on the map
            // You can customize this based on your needs
          },
          child: Icon(Icons.my_location),
        ),
      );
    }

    Widget _buildMap() {
      if (_selectedLocation == null) {
        return Center(child: CircularProgressIndicator());
      } else {
        return GoogleMap(
          key: _mapKey,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              _selectedLocation!.latitude,
              _selectedLocation!.longitude,
            ),
            zoom: 15.0,
          ),
          markers: _markers,
          myLocationEnabled: true,
          onMapCreated: (controller) {
            _controllerCompleter.complete(controller);
            _setInitialCameraPosition(controller);
          },
        );
      }
    }

    Future<void> _loadUserLocation() async {
      if (!isUserLocationLoaded) {
        MyBoardUser? user = await UserRepository().initUser();

        if (user != null && user.location != null) {
          setState(() {
            _selectedLocation = SelectLocationDTO(
              latitude: user.location!.latitude,
              longitude: user.location!.longitude,
              name: 'Current Location',
            );

            isUserLocationLoaded = true;
          });
        }
      }
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

    void _loadUserDisplays() async {
      try {
        List<DisplayDetails> userDisplays =
            await DisplayRepository().getMyDisplays();

        setState(() {
          _markers = userDisplays
              .map((display) => Marker(
                    markerId: MarkerId(display.id),
                    position: LatLng(display.latitude, display.longitude),
                    // Custom marker icon based on condition
                    icon: markerIcon,
                  ))
              .toSet();
        });
      } catch (e) {
        // Handle error case
        print('Failed to load user displays: $e');
      }
    }

    void _loadCustomMarkerIcons() {
      BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(), "assets/display-map-marker.png")
          .then(
        (icon) {
          setState(() {
            markerIcon = icon;
          });
        },
      );
    }
  }
