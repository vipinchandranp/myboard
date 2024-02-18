import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myboard/bloc/display/display_cubit.dart';
import 'package:myboard/bloc/map/map_cubit.dart';
import 'package:myboard/bloc/map/map_state.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/models/location_search.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/repositories/display_repository.dart';
import 'package:myboard/repositories/map_repository.dart';
import 'package:myboard/repositories/user_repository.dart';
import 'package:myboard/screens/common_slidefrombottom_screen.dart';
import 'package:myboard/screens/createboard_displaydetails_content_screen.dart';

class SelectDisplayMap extends StatefulWidget {
  final MyBoardUser? user;
  final Function(Map<String, dynamic>) onDisplaySelected;

  SelectDisplayMap({required this.user, required this.onDisplaySelected});

  _SelectDisplayMapState createState() => _SelectDisplayMapState();
}

class _SelectDisplayMapState extends State<SelectDisplayMap> {
  late DisplayRepository displayRepository;
  late DisplayCubit displayCubit;
  late MapCubit mapCubit;
  final Key _mapKey = UniqueKey();
  late MapRepository mapRepository; // Add this line
  Completer<GoogleMapController> _controllerCompleter = Completer();
  late SelectLocationDTO _selectedLocation =
      SelectLocationDTO(name: '', latitude: 0, longitude: 0);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor selectedMarkerIcon = BitmapDescriptor.defaultMarker;
  BoardDisplayDetails? _selectedDisplayDetails;
  bool _bottomSheetOpen = false; // Track bottom sheet state
  bool _showMyDisplays = false;

  @override
  void initState() {
    super.initState();
    displayRepository = DisplayRepository();
    mapRepository = MapRepository();
    displayCubit = BlocProvider.of<DisplayCubit>(context);
    mapCubit = BlocProvider.of<MapCubit>(context);

    addCustomIcon();
    _initUserLocation();
    _loadNearbyDisplays(_selectedLocation);
    // Listen to state changes and update the map
    mapCubit.stream.listen((state) {
      if (state is SelectedLocation) {
        // Update the selected location
        setState(() {
          _selectedLocation = state.selectedLocation;
        });

        // Animate to the updated selected location
        _controllerCompleter.future.then((controller) {
          _animateToSelectedLocation(controller, _selectedLocation);
        });

        // Load nearby displays for the updated location
        _loadNearbyDisplays(_selectedLocation);
      }
    });
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/display-map-marker.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(),
            "assets/display-map-marker-selected.png")
        .then(
      (icon) {
        setState(() {
          selectedMarkerIcon = icon;
        });
      },
    );
  }

  void _loadNearbyDisplays(SelectLocationDTO? location) async {
    if (location == null) {
      print('_selectedLocation is null');
      return;
    }

    try {
      mapCubit.getDisplaysNearby(location);
      // Implement the logic to use the nearbyDisplays, e.g., update markers on the map
    } catch (e) {
      print('Error loading nearby displays: $e');
    }
  }

  @override
  void dispose() {
    displayCubit.close(); // Close the stream when the widget is disposed
    super.dispose();
  }

  Future<void> _initUserLocation() async {
    try {
      MyBoardUser? user = await UserRepository().initUser();

      if (user.location != null) {
        setState(() {
          _selectedLocation = SelectLocationDTO(
            name: user.location!.name,
            latitude: user.location!.latitude,
            longitude: user.location!.longitude,
          );
        });
      }
    } catch (e) {
      print('Error initializing user location: $e');
    }
  }

  void _reloadMap() {
    // Fetch displays based on the selected option
    if (_showMyDisplays) {
      // Fetch displays for the logged-in user
      _fetchMyDisplays();
    } else {
      // Fetch all displays
      _getDisplays();
    }
  }

  void _toggleMyDisplays() {
    setState(() {
      _showMyDisplays = !_showMyDisplays;
    });
    // Reload the map with displays based on the selected option
    _reloadMap();
  }

  Future<List<DisplayDetails>> _getDisplays() async {
    try {
      return await displayRepository.getAllDisplays();
    } catch (e) {
      print('Error getting displays: $e');
      return []; // Handle error accordingly
    }
  }

  Future<List<DisplayDetails>> _fetchMyDisplays() async {
    try {
      return await displayRepository.getMyDisplays();
    } catch (e) {
      print('Error getting displays: $e');
      return []; // Handle error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('All Displays'),
                Switch(
                  value: _showMyDisplays,
                  onChanged: (value) {
                    _toggleMyDisplays();
                  },
                ),
                Text('My Displays'),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<DisplayDetails>>(
                future: _showMyDisplays ? _fetchMyDisplays() : _getDisplays(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return AbsorbPointer(
                      absorbing: _bottomSheetOpen,
                      // Disable interactions with the map if the bottom sheet is open
                      child: Container(
                        child: GoogleMap(
                          key: _mapKey,
                          onMapCreated: (controller) {
                            _controllerCompleter.complete(controller);

                            // Animate to the selected location when the map is created
                            _animateToSelectedLocation(
                                controller, _selectedLocation);
                          },
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              _selectedLocation.latitude,
                              _selectedLocation.longitude,
                            ),
                            zoom: 15.0,
                          ),
                          markers: _getMarkers(snapshot.data!),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Set<Marker> _getMarkers(List<DisplayDetails> displays) {
    Set<Marker> markers = Set();

    for (DisplayDetails displayDetails in displays) {
      bool isSelectedMarker = displayDetails.id == _selectedDisplayDetails?.id;

      markers.add(Marker(
        markerId: MarkerId(displayDetails.id),
        position: LatLng(
          displayDetails.latitude,
          displayDetails.longitude,
        ),
        onTap: () {
          // Create a new instance of BoardDisplayDetails
          BoardDisplayDetails selectedDisplayDetails = BoardDisplayDetails(
            id: displayDetails.id,
          );

          setState(() {
            _selectedDisplayDetails = selectedDisplayDetails;
          });

          _showBottonSlideSheetForDisplayDetails(displayDetails);
        },
        icon: isSelectedMarker ? selectedMarkerIcon : markerIcon,
      ));
    }

    return markers;
  }

  void _showBottonSlideSheetForDisplayDetails(DisplayDetails displayDetails) {
    setState(() {
      _bottomSheetOpen = true; // Set bottom sheet state to open
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Show the sheet in the center of the screen
      enableDrag: true, // Enable dragging to prevent automatic closing
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {}, // Prevent closing when tapping on the sheet
          child: CustomSlideSheet(
            // Your bottom sheet content
            child: DisplayDetailsDrawerContent(
              displayDetails: displayDetails,
              onDateTimeSelected: (date, timeSlots) {
                // Pass date and timeSlots back to CreateBoardScreen
                widget.onDisplaySelected({
                  'date': date,
                  'timeSlots': timeSlots,
                  'displayDetails': displayDetails
                });
              },
            ),
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        _bottomSheetOpen = false; // Set bottom sheet state to closed
      });
    });
  }

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
