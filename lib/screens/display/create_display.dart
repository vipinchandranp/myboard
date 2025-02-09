import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:myboard/screens/display/select_display_location.dart';

import '../../api_models/display_save.dart';
import '../../repository/display_repository.dart';

class CreateDisplayWidget extends StatefulWidget {
  @override
  _CreateDisplayWidgetState createState() => _CreateDisplayWidgetState();
}

class _CreateDisplayWidgetState extends State<CreateDisplayWidget> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<File> _mediaFiles = [];
  String? _selectedAddress;
  LatLng _selectedLocation = LatLng(12.9716, 77.5946); // Default to Bangalore
  bool _isUploading = false;

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
      setState(() {
        _selectedAddress = 'Address not found';
      });
    }
  }

  Future<void> _navigateToMap(BuildContext context) async {
    final LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectLocationWidget(
          initialLocation: _selectedLocation,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result;
      });
      _fetchAddress(result);
    }
  }

  Future<void> _pickMedia() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _mediaFiles.add(File(pickedFile.path));
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
                file,
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

  Future<void> _saveDisplay() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all required fields.')));
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      SaveDisplay saveDisplay = SaveDisplay(
        displayName: _displayNameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
        files: _mediaFiles,
      );

      var response = await DisplayService(context).saveDisplay(saveDisplay);
      if (response != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response)));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to save display.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error saving display: $e')));
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a display name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price per Hour (in Rupees)',
                    border: OutlineInputBorder(),
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
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _navigateToMap(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedAddress ?? 'Select Location',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  onPressed: _isUploading ? null : _saveDisplay,
                  child: Text(
                    _isUploading ? 'Saving...' : 'Save Display',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}