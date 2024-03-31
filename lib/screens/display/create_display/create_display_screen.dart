import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myboard/bloc/map/map_cubit.dart';
import 'package:myboard/bloc/map/map_state.dart';
import 'package:myboard/bloc/user/user_cubit.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/models/location_search.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/repositories/user_repository.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:myboard/utils/Constants.dart';

class CreateDisplayScreen extends StatefulWidget {
  @override
  _CreateDisplayScreenState createState() => _CreateDisplayScreenState();
}

class _CreateDisplayScreenState extends State<CreateDisplayScreen> {
  late TextEditingController descriptionController;
  late TextEditingController nameController;
  Set<Marker> _markers = {};
  SelectLocationDTO? _selectedLocation;
  Key _mapKey = UniqueKey();
  XFile? _pickedFile;
  final ImagePicker _imagePicker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isMovingDisplay = false;
  List<LatLng> _movingPath = [];

  bool isLoading = true;
  late MapCubit mapCubit;
  Completer<GoogleMapController> _controllerCompleter = Completer();
  bool isUserLocationLoaded = false;
  late String googleApiKey =
      "YOUR_GOOGLE_API_KEY_HERE"; // Replace with your actual API key

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
    nameController = TextEditingController();
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
  void dispose() {
    descriptionController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _toggleMovingDisplay(bool value) {
    setState(() {
      _isMovingDisplay = value;
      if (!_isMovingDisplay) {
        _movingPath.clear();
      }
    });
  }

  void _updateSelectedLocation(SelectedLocation state) {
    setState(() {
      _selectedLocation = state.selectedLocation;
      _mapKey = UniqueKey();
    });
  }

  void _createDisplay() {
    if (_formKey.currentState?.validate() ?? false) {
      final DisplayDetails displayDetails = DisplayDetails(
        id: 'customId',
        latitude: _selectedLocation?.latitude ?? 0.0,
        longitude: _selectedLocation?.longitude ?? 0.0,
        description: descriptionController.text,
        displayName: nameController.text,
        comments: [],
        rating: 0.0,
        userId: 'defaultUserId',
        images: _pickedFile != null ? [_pickedFile!] : null,
        userName: '',
        fileName: '',
      );

      final userCubit = BlocProvider.of<UserCubit>(context);
      userCubit.saveDisplay(context, displayDetails).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Display saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving display: $error'),
            duration: Duration(seconds: 2),
          ),
        );
      });

      print(displayDetails.toJson());
    }
  }

  Future<void> _getImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedFile = pickedFile;
    });
  }

  void _onMapTap(LatLng position) async {
    try {
      ByteData byteData = await rootBundle.load('assets/display_pin.png');
      Uint8List imageData = byteData.buffer.asUint8List();

      setState(() {
        _markers.clear();
        _markers.add(Marker(
          markerId: MarkerId('selected-location'),
          position: position,
          icon: BitmapDescriptor.fromBytes(imageData),
        ));
        _selectedLocation = SelectLocationDTO(
          latitude: position.latitude,
          longitude: position.longitude,
          name: 'Selected Location',
        );

        if (_isMovingDisplay) {
          _movingPath.add(position);
          _drawMovingPath();
        }
      });
    } catch (e) {
      print('Error loading marker image: $e');
    }
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
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
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
                      SizedBox(height: 16),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Display Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Display Name is mandatory.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _getImage,
                              child: Text('Upload photo of your Display'),
                            ),
                            if (_pickedFile != null)
                              Column(
                                children: [
                                  Image.network(
                                    _pickedFile!.path,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(height: 16),
                                  Text('Uploaded Photo of your Display:'),
                                ],
                              ),
                            SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed:
                                  _markers.isEmpty ? null : _createDisplay,
                              icon: Icon(Icons.save),
                              label: Text('Save Display'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(16.0),
                                textStyle: TextStyle(fontSize: 18),
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Text('Moving Display'),
                                SizedBox(width: 16),
                                Switch(
                                  value: _isMovingDisplay,
                                  onChanged: _toggleMovingDisplay,
                                ),
                              ],
                            ),
                            if (_markers.isEmpty)
                              Text(
                                'Please pin your display location on the map.',
                                style: TextStyle(color: Colors.red),
                              ),
                          ],
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
        onPressed: () {},
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
        onTap: _onMapTap,
        myLocationEnabled: true,
        onMapCreated: (controller) {
          _controllerCompleter.complete(controller);
          _setInitialCameraPosition(controller);
        },
        polylines: _isMovingDisplay ? _createPolylines() : {},
      );
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

  Set<Polyline> _createPolylines() {
    if (_movingPath.isEmpty || _movingPath.length < 2) {
      return {};
    }

    return {
      Polyline(
        polylineId: PolylineId('moving-path'),
        points: _movingPath,
        color: Colors.blue,
        width: 4,
      ),
    };
  }

  void _drawMovingPath() async {
    if (_movingPath.length > 1) {
      try {
        PolylinePoints polylinePoints = PolylinePoints();
        PointLatLng startPoint = PointLatLng(
            _movingPath.first.latitude, _movingPath.first.longitude);
        PointLatLng endPoint =
            PointLatLng(_movingPath.last.latitude, _movingPath.last.longitude);

        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          google_api_key,
          startPoint,
          endPoint,
        );

        if (result.points.isNotEmpty) {
          setState(() {
            _markers.clear();
            _markers.add(Marker(
              markerId: MarkerId('selected-location'),
              position: _movingPath.last,
              icon: BitmapDescriptor.defaultMarker,
            ));

            List<LatLng> decodedPolyline =
                result.points.map((PointLatLng point) {
              return LatLng(point.latitude, point.longitude);
            }).toList();

            _movingPath.clear();
            _movingPath.addAll(decodedPolyline);
          });
        }
      } catch (e) {
        print('Error fetching route: $e');
      }
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
}
