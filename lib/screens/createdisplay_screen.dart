import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myboard/bloc/map/map_cubit.dart';
import 'package:myboard/bloc/map/map_state.dart';
import 'package:myboard/bloc/user/user_cubit.dart';
import 'package:myboard/bloc/user/user_state.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/models/location_search.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/repositories/user_repository.dart';

class CreateDisplayScreen extends StatefulWidget {
  @override
  _CreateDisplayScreenState createState() => _CreateDisplayScreenState();
}

class _CreateDisplayScreenState extends State<CreateDisplayScreen> {
  late TextEditingController descriptionController;
  late TextEditingController nameController;
  Set<Marker> _markers = {}; // Initialize as empty set
  SelectLocationDTO? _selectedLocation;
  Key _mapKey = UniqueKey();
  XFile? _pickedFile;
  final ImagePicker _imagePicker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  late MapCubit mapCubit;
  Completer<GoogleMapController> _controllerCompleter = Completer();
  bool isUserLocationLoaded = false;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
    nameController = TextEditingController();
    mapCubit = BlocProvider.of<MapCubit>(context);

    // Load user's initial location only if it's not already loaded
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

  void _updateSelectedLocation(SelectedLocation state) {
    setState(() {
      _selectedLocation = state.selectedLocation;
      _mapKey = UniqueKey(); // Update the key
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
      userCubit.saveDisplay(context, displayDetails);

      BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is DisplaySaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Display saved successfully'),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error saving display: ${state.message}'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: Container(),
      );

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
      ByteData byteData =
          await rootBundle.load('assets/display-map-marker.png');
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
            flex: 1,
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration:
                              InputDecoration(labelText: 'Display Name'),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Display Name is mandatory.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: descriptionController,
                          maxLines: 20,
                          decoration:
                              InputDecoration(labelText: 'Display Description'),
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
                          onPressed: _createDisplay,
                          icon: Icon(Icons.save),
                          label: Text('Save Display'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(16.0),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: _buildMap(),
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
      return Stack(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.progress, // Set the cursor type here
            child: GoogleMap(
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
            ),
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'Latitude: ${_selectedLocation!.latitude}\nLongitude: ${_selectedLocation!.longitude}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
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
}
