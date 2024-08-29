import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:myboard/bloc/map/map_cubit.dart';
import 'package:myboard/bloc/map/map_state.dart';
import 'package:myboard/models/location_search.dart';
import 'package:myboard/models/route.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/repositories/route-repository.dart';
import 'package:myboard/repositories/user_repository.dart';
import 'package:myboard/utils/Constants.dart';

class ViewRouteScreen extends StatefulWidget {
  @override
  _ViewRouteScreenState createState() => _ViewRouteScreenState();
}

class _ViewRouteScreenState extends State<ViewRouteScreen> {
  late RouteModel _selectedRoute = RouteModel(name: '', locations: []);
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late MapCubit mapCubit;
  bool isUserLocationLoaded = false;
  SelectLocationDTO? _selectedLocation;
  Key _mapKey = UniqueKey();
  Completer<GoogleMapController> _controller = Completer();
  late List<RouteModel> _routes = []; // List to store fetched routes
  RouteModel? _selectedDropdownRoute; // Currently selected route from dropdown
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    mapCubit = BlocProvider.of<MapCubit>(context);

    if (!isUserLocationLoaded) {
      _loadUserLocation();
    }

    mapCubit.stream.listen((state) {
      if (state is SelectedLocation) {
        _updateSelectedLocation(state);
      }
    });

    // Fetch routes when the screen initializes
    _fetchRoutes();
  }

  Future<void> _fetchRoutes() async {
    try {
      // Fetch routes from the repository
      List<RouteModel> routes = await RouteRepository().getAllRoutes();
      setState(() {
        _routes = routes;
        // Preselect the first route if available
        if (_routes.isNotEmpty) {
          _selectedDropdownRoute = _routes.first;
          print(_selectedDropdownRoute);
          // Update the selected route on the map
          _updateSelectedRouteOnMap(_selectedDropdownRoute);
        }
      });
    } catch (e) {
      print('Failed to fetch routes: $e');
      // Handle error case
    }
  }

  void _updateSelectedLocation(SelectedLocation state) {
    setState(() {
      _selectedLocation = state.selectedLocation;
      _mapKey = UniqueKey();
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: DropdownButtonFormField<RouteModel>(
              value: _selectedDropdownRoute,
              items: _routes.map((route) {
                return DropdownMenuItem<RouteModel>(
                  value: route,
                  child: Text(route.name, style: TextStyle(fontSize: 18)),
                );
              }).toList(),
              onChanged: (RouteModel? value) {
                if (value == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a route')),
                  );
                } else {
                  setState(() {
                    _selectedDropdownRoute = value;
                    // Update the selected route on the map
                    _updateSelectedRouteOnMap(value);
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Select Route',
                labelStyle: TextStyle(fontSize: 20),
                border: OutlineInputBorder(),
                errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
              ),
              validator: (value) {
                if (value == null) {
                  return 'Please select a route';
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Builder(
                  builder: (BuildContext context) {
                    return GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          _selectedLocation!.latitude,
                          _selectedLocation!.longitude,
                        ),
                        zoom: 15.0,
                      ),
                      markers: _markers,
                      polylines: _polylines,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updateSelectedRouteOnMap(RouteModel? route) {
    if (route != null) {
      setState(() {
        _selectedRoute = route;
        // Generate a new unique key for the Google Map widget
        _mapKey = UniqueKey();
      });

      // Clear existing markers and polylines
      _clearMap();

      // Draw markers for start and end locations
      _drawMarkers();

      // Draw polyline for the route
      _drawPolyline(
        LatLng(
          _selectedRoute.locations.first.latitude,
          _selectedRoute.locations.first.longitude,
        ),
        LatLng(
          _selectedRoute.locations.last.latitude,
          _selectedRoute.locations.last.longitude,
        ),
      );
    }
  }

  void _clearMap() {
    // Clear markers
    _markers.clear();

    // Clear polylines
    _polylines.clear();
  }

  void _drawMarkers() {
    // Check if the locations list is not empty
    if (_selectedRoute.locations.isNotEmpty) {
      // Add markers for start and end locations
      _markers.addAll([
        Marker(
          markerId: MarkerId('start'),
          position: LatLng(
            _selectedRoute.locations.first.latitude,
            _selectedRoute.locations.first.longitude,
          ),
        ),
        Marker(
          markerId: MarkerId('end'),
          position: LatLng(
            _selectedRoute.locations.last.latitude,
            _selectedRoute.locations.last.longitude,
          ),
        ),
      ]);
    }
  }

  void _drawPolyline(LatLng source, LatLng destination) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, // Replace google_api_key with your actual API key
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      // Convert polyline points to LatLng objects
      List<LatLng> polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      // Add polyline to the map
      setState(() {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        );
      });
    }
  }
}
