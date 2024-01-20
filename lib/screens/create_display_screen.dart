import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myboard/bloc/user/user_cubit.dart';
import 'package:myboard/bloc/user/user_state.dart';
import 'package:myboard/models/display_details.dart';

class CreateDisplayScreen extends StatefulWidget {
  @override
  _CreateDisplayScreenState createState() => _CreateDisplayScreenState();
}

class _CreateDisplayScreenState extends State<CreateDisplayScreen> {
  late TextEditingController descriptionController;
  late TextEditingController nameController;
  List<XFile>? selectedImages;
  final Set<Marker> _markers = {};
  LatLng? _selectedLocation;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    nameController.dispose();
    super.dispose();
  }

// Assuming this function is part of a StatefulWidget
  void _createDisplay() {
    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, proceed with creating the display
      final DisplayDetails displayDetails = DisplayDetails(
        id: 'customId',
        latitude: _selectedLocation?.latitude ?? 0.0,
        longitude: _selectedLocation?.longitude ?? 0.0,
        description: descriptionController.text,
        displayName: nameController.text,
        // Include displayName
        comments: [],
        rating: 0.0,
        userId: 'defaultUserId',
        images: selectedImages,
        userName: '',
        fileName: '',
      );

      // Access UserCubit through BlocProvider
      final userCubit = BlocProvider.of<UserCubit>(context);

      // Save displayDetails to the backend using the UserCubit
      userCubit.saveDisplay(context, displayDetails);

      // You can optionally listen for state changes and react accordingly
      // For example, show a loading indicator or handle success/error states
      BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is DisplaySaved) {
            // Handle display saved state (e.g., show a success message)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Display saved successfully'),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is UserError) {
            // Handle error state (e.g., show an error message)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error saving display: ${state.message}'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: Container(), // Replace with your UI widgets
      );

      // Use or save displayDetails as needed
      print(displayDetails.toJson());
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? result = await ImagePicker().pickMultiImage();
    if (result != null && result.isNotEmpty) {
      setState(() {
        selectedImages = result;
      });
    }
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId('selected-location'),
        position: position,
      ));
      _selectedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Display Name'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Display Name is mandatory.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _pickImages,
                      child: Text('Pick Images'),
                    ),
                    SizedBox(height: 16),
                    if (selectedImages != null && selectedImages!.isNotEmpty)
                      Expanded(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: selectedImages!.map((image) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                  ),
                                  child: Image.network(
                                    image.path,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
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
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(20.5937, 78.9629), // Centered on India
                    zoom: 4.0, // Adjust the zoom level as needed
                  ),
                  markers: _markers,
                  onTap: _onMapTap,
                  myLocationEnabled: true,
                ),
                if (_selectedLocation != null)
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
}
