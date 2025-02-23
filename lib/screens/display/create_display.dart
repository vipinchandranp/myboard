import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:myboard/screens/display/select_display_location.dart';

import '../../api_models/display_save.dart';
import '../../models/common/media_file.dart';
import '../../models/display/bdisplay.dart';
import '../../repository/display_repository.dart';

class CreateDisplayWidget extends StatefulWidget {
  // Optional displayId indicates edit mode; if null, then it's create mode.
  final String? displayId;

  CreateDisplayWidget({this.displayId});

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
  bool _isPriceEnabled = false; // Toggle for enabling price input

  @override
  void initState() {
    super.initState();
    // If a displayId is provided, load the display details for editing.
    if (widget.displayId != null) {
      _loadDisplayDetails(widget.displayId!);
    }
  }
  Future<void> _loadDisplayDetails(String displayId) async {
    // Fetch display details using the repository API call.
    BDisplay? display = await DisplayService(context).getDisplayById(displayId);
    if (display != null) {
      // Process media files: if the file path is a URL, convert it asynchronously.
      List<File> localMediaFiles = [];
      for (var media in display.mediaFiles) {
        String path = media.filename;
        if (path.startsWith("http")) {
          // Create a JSON map to pass to the async factory method.
          Map<String, dynamic> mediaJson = {
            'filePath': path,
            'fileName': media.filename,
            'mediaType': media.mediaType.toString().split('.').last,
          };
          // Download and convert the remote file.
          MediaFile convertedMedia = await MediaFile.fromJsonAsync(mediaJson);
          localMediaFiles.add(convertedMedia.file);
        } else {
          localMediaFiles.add(media.file);
        }
      }

      setState(() {
        _displayNameController.text = display.displayName;
        if (display.price != null) {
          _priceController.text = display.price.toString();
          _isPriceEnabled = true;
        }
        _mediaFiles = localMediaFiles;
        if (display.latitude != null && display.longitude != null) {
          _selectedLocation = LatLng(display.latitude!, display.longitude!);
          _fetchAddress(_selectedLocation);
        }
      });
    }
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
      // Only parse price if enabled; otherwise, set to null.
      double? price;
      if (_isPriceEnabled) {
        price = double.parse(_priceController.text.trim());
      }

      SaveDisplay saveDisplay = SaveDisplay(
        displayName: _displayNameController.text.trim(),
        price: price,
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
  void dispose() {
    _displayNameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.displayId != null ? 'Edit Display' : 'Create Display'),
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
                // Display Name
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
                // Toggle for enabling price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Set Price for Display?'),
                    Switch(
                      value: _isPriceEnabled,
                      onChanged: (value) {
                        setState(() {
                          _isPriceEnabled = value;
                          if (!value) {
                            _priceController.clear();
                          }
                        });
                      },
                    ),
                  ],
                ),
                // Price Input Field (visible only if enabled)
                if (_isPriceEnabled)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Price per Hour (in Rupees)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (_isPriceEnabled) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                // Location Selector
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
                // Add Media Button
                ElevatedButton.icon(
                  onPressed: _pickMedia,
                  icon: Icon(Icons.add_photo_alternate),
                  label: Text('Add Media'),
                ),
                SizedBox(height: 16),
                // Media Preview
                _buildMediaPreview(),
                SizedBox(height: 16),
                // Save Display Button
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
