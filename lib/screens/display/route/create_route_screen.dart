import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'dart:math' show cos, sin, sqrt, atan2, pi;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_map_marker_animation/widgets/animarker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:myboard/bloc/map/map_cubit.dart';
import 'package:myboard/bloc/map/map_state.dart';
import 'package:myboard/models/location_search.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/repositories/user_repository.dart';
import 'package:myboard/utils/Constants.dart';

class CreateRouteScreen extends StatefulWidget {
  @override
  _CreateRouteScreenState createState() => _CreateRouteScreenState();
}

class _CreateRouteScreenState extends State<CreateRouteScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _locations = [];
  String _routeName = '';
  Map<int, LatLng> _redoLocations = {};
  Map<int, MarkerId> _markerIds = {};
  late MapCubit mapCubit;
  LatLng?
      _selectedUserLocation; // Add this variable to store the selected user location
  bool isUserLocationLoaded = false;
  SelectLocationDTO? _selectedLocation;
  Key _mapKey = UniqueKey();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanUpdate: (details) {
                // Handle dragging logic here
                // Check if the polyline is being dragged
                // You can use details.localPosition to get the position of the drag event
              },
              child: Stack(
                children: [
                  Animarker(
                    curve: Curves.ease,
                    mapId: _controller.future.then<int>((value) => value.mapId),
                    //Grab Google Map Id
                    markers: _markers,
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      onTap: _onMapTap,
                      markers: _markers,
                      polylines: _polylines,
                      key: _mapKey,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          _selectedLocation!.latitude,
                          _selectedLocation!.longitude,
                        ),
                        zoom: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 200, // Adjust the width as needed
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _routeName = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Route Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveRoute,
                    child: Text('Save Route'),
                  ),
                  SizedBox(height: 16),
                  IconButton(
                    icon: Icon(Icons.undo),
                    onPressed: _undo,
                  ),
                  IconButton(
                    icon: Icon(Icons.redo),
                    onPressed: _redo,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

  void _updateSelectedLocation(SelectedLocation state) {
    setState(() {
      _selectedLocation = state.selectedLocation;
      _mapKey = UniqueKey();
    });
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      _locations.add(latLng);
      MarkerId markerId = MarkerId('${_locations.length}');
      _markerIds[_locations.length] = markerId;
      _markers.add(
        Marker(
          markerId: markerId,
          position: latLng,
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      if (_locations.length >= 2) {
        _fetchRoute();
      }
    });
  }

  void _saveRoute() {
    // Implement saving route functionality here
    // You can use _locations and _routeName
  }

  void _undo() {
    setState(() {
      if (_locations.isNotEmpty) {
        int lastIndex = _locations.length;
        _locations.removeLast();
        MarkerId? markerId = _markerIds.remove(lastIndex);
        if (markerId != null) {
          _markers.removeWhere((marker) => marker.markerId == markerId);
        }
        _polylines.removeWhere(
          (polyline) =>
              polyline.polylineId ==
              PolylineId('route${_locations.length + 1}'),
        );
      }
    });
  }

  void _redo() {
    setState(() {
      // Check if there are any undone locations in _redoLocations
      if (_redoLocations.isNotEmpty) {
        int redoIndex = _locations.length + 1;
        LatLng? redoLocation = _redoLocations.remove(redoIndex);
        if (redoLocation != null) {
          MarkerId markerId = MarkerId('$redoIndex');
          _markerIds[redoIndex] = markerId;
          _markers.add(
            Marker(
              markerId: markerId,
              position: redoLocation,
              icon: BitmapDescriptor.defaultMarker,
            ),
          );

          // Fetch and draw the polyline for the redo location
          if (_locations.length >= 2) {
            _fetchRoute();
          }
        }
      }
    });
  }

  double _calculateBearing(LatLng start, LatLng end) {
    double startLat = _degreesToRadians(start.latitude);
    double startLng = _degreesToRadians(start.longitude);
    double endLat = _degreesToRadians(end.latitude);
    double endLng = _degreesToRadians(end.longitude);

    double deltaLng = endLng - startLng;

    double y = sin(deltaLng) * cos(endLat);
    double x = cos(startLat) * sin(endLat) -
        sin(startLat) * cos(endLat) * cos(deltaLng);
    double bearing = atan2(y, x);

    return _radiansToDegrees(bearing);
  }

  double _degreesToRadians(degrees) {
    return degrees * pi / 180;
  }

  double _radiansToDegrees(radians) {
    return radians * 180 / pi;
  }

  void _fetchRoute() async {
    if (_locations.length >= 2) {
      _polylines.clear(); // Clear previous polylines

      for (int i = 0; i < _locations.length - 1; i++) {
        LatLng start = _locations[i];
        LatLng end = _locations[i + 1];

        // Fetch route between two consecutive points
        PolylinePoints polylinePoints = PolylinePoints();
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          google_api_key,
          PointLatLng(start.latitude, start.longitude),
          PointLatLng(end.latitude, end.longitude),
        );

        if (result.points.isNotEmpty) {
          List<LatLng> polylineCoordinates = [];
          result.points.forEach((PointLatLng point) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });

          // Add polyline to display the route
          _polylines.add(Polyline(
            polylineId: PolylineId('route$i'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 6,
          ));

          // Calculate bearing between two consecutive points
          double bearing = _calculateBearing(start, end);

          // Add arrow marker at the end of the polyline
          _markers.add(Marker(
            markerId: MarkerId('arrow$i'),
            position: end,
            icon: await _createArrowIcon(
                bearing), // Create arrow icon based on bearing
          ));
        }
      }

      setState(() {});
    }
  }

// Inside _fetchRoute method
  Future<BitmapDescriptor> _createArrowIcon(double bearing) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    final double size = 40.0;
    final double arrowSize = 8.0;

    canvas.translate(size / 2, size / 2);
    canvas.rotate(_degreesToRadians(bearing));

    final Path path = Path();
    path.moveTo(-arrowSize / 2, -size / 2);
    path.lineTo(arrowSize / 2, -size / 2);
    path.lineTo(0, size / 2);
    path.close();

    canvas.drawPath(path, paint);

    final ui.Picture picture = pictureRecorder.endRecording();
    final ui.Image image = await picture.toImage(size.toInt(), size.toInt());
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(pngBytes);
  }
}
