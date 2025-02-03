import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:geocoding/geocoding.dart';
import '../../api_models/display_save.dart';
import '../../models/common/media_type.dart';
import '../../models/display/display_media_file.dart';
import '../../repository/display_repository.dart';

class CreateDisplayWidget extends StatefulWidget {
  @override
  _CreateDisplayWidgetState createState() => _CreateDisplayWidgetState();
}

class _CreateDisplayWidgetState extends State<CreateDisplayWidget> {
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<File> _mediaFiles = [];
  List<VideoPlayerController> _videoControllers = [];
  bool _isUploading = false;
  String _displayName = "";
  double _pricePerHour = 0.0;
  LatLng _selectedLocation = LatLng(12.9716, 77.5946); // Default to Bangalore
  String? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _fetchAddress(_selectedLocation);
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchAddress(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _selectedAddress =
          "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
        });
      }
    } catch (e) {
      print('Error fetching address: $e');
      setState(() {
        _selectedAddress = 'Address not found';
      });
    }
  }

  Future<void> _pickMedia() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _mediaFiles.add(File(pickedFile.path)); // Add the file correctly
      });
    }
  }

  Widget _buildMediaPreview() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _mediaFiles.map((file) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                file, // Directly use the File object
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _mediaFiles.remove(file);
                  });
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMapWidget() {
    return Expanded(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 12,
            ),
            markers: {
              Marker(
                markerId: MarkerId('selected-location'),
                position: _selectedLocation,
                draggable: true,
                onDragEnd: (LatLng newPosition) {
                  setState(() {
                    _selectedLocation = newPosition;
                  });
                  _fetchAddress(newPosition);
                },
              ),
            },
            onCameraMove: (CameraPosition position) {
              setState(() {
                _selectedLocation = position.target;
              });
            },
            onCameraIdle: () {
              _fetchAddress(_selectedLocation);
            },
          ),
          if (_selectedAddress != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  'Selected Address: $_selectedAddress',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _saveDisplay() async {
    // Check form state before proceeding
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all required fields.')));
      return;
    }

    // If form is valid, proceed to save
    setState(() {
      _isUploading = true;
    });

    try {
      // Gather the display details into a SaveDisplay object
      SaveDisplay saveDisplay = SaveDisplay(
        displayName: _displayNameController.text, // Ensure you're using the controller's text directly
        price: double.tryParse(_priceController.text) ?? 0.0, // Same for price
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
        files: _mediaFiles, // Assuming _mediaFiles is a list of File objects
      );

      // Call the SaveDisplayService to save the display
      var response = await DisplayService(context).saveDisplay(saveDisplay);
      if (response != null ) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save display.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving display: $e')));
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Display'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Form(  // Wrap the form fields inside Form
            key: _formKey, // Use the form key here
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a display name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _displayName = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price per Hour (in Rupees)',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _pricePerHour = double.tryParse(value) ?? 0.0;
                    });
                  },
                ),
                SizedBox(height: 16),
                Container(
                  height: 300,
                  child: _buildMapWidget(),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickMedia,
                  icon: Icon(Icons.add_photo_alternate),
                  label: Text('Add Media'),
                ),
                SizedBox(height: 16),
                _buildMediaPreview(),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveDisplay,
                  child: Text('Save Display'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
