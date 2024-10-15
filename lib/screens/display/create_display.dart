import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:geocoding/geocoding.dart';
import '../../models/common/media_type.dart';
import '../../models/display/display_geotag_request.dart';
import '../../models/display/display_media_file.dart';
import '../../repository/display_repository.dart';
import 'explore_display_on_map.dart';

class CreateDisplayWidget extends StatefulWidget {
  final BuildContext context;

  CreateDisplayWidget(this.context);

  @override
  _CreateDisplayWidgetState createState() => _CreateDisplayWidgetState();
}

class _CreateDisplayWidgetState extends State<CreateDisplayWidget> {
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _displayNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<DisplayMediaFile> _mediaFiles = [];
  List<VideoPlayerController> _videoControllers = [];
  bool _isUploading = false;
  String _displayName = "";
  LatLng? _selectedLocation;
  String? _selectedAddress;

  late DisplayService _displayService;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    _displayService = DisplayService(widget.context);
  }

  Future<void> _pickMedia() async {
    if (!_formKey.currentState!.validate()) return;

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _uploadMedia(File(pickedFile.path), MediaType.image);
    } else {
      final pickedVideo = await _picker.pickVideo(source: ImageSource.gallery);
      if (pickedVideo != null) {
        final videoController =
            VideoPlayerController.file(File(pickedVideo.path));
        await videoController.initialize();
        await _uploadMedia(File(pickedVideo.path), MediaType.video);
        setState(() {
          _videoControllers.add(videoController);
        });
      }
    }
  }

  Future<void> _uploadMedia(File file, MediaType mediaType) async {
    setState(() {
      _isUploading = true;
    });

    try {
      final data = await _displayService.saveDisplay(file, _displayName);

      if (data != null) {
        setState(() {
          _mediaFiles.add(
            DisplayMediaFile(
              file: file,
              displayId: data['displayId'],
              filename: data['fileName'],
              mediaType: mediaType,
            ),
          );
        });
        _scrollToBottom();
      } else {
        _showSnackBar('Failed to upload media. Please try again.');
      }
    } catch (e) {
      print('Error uploading media: $e');
      _showSnackBar('Error uploading media. Please try again.');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _geoTagDisplay() async {
    if (_selectedLocation == null || _mediaFiles.isEmpty) {
      _showSnackBar('Please select a location and upload media first.');
      return;
    }

    try {
      final lastUploadedMedia = _mediaFiles
          .last; // Assuming the last uploaded media is to be geo-tagged
      final geoTagRequest = DisplayGeoTagRequest(
        displayId: lastUploadedMedia.displayId,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
      );

      final success = await _displayService.geoTagDisplay(
          geoTagRequest);
      if (success) {
        _showSnackBar('Display geo-tagged successfully!');
      } else {
        _showSnackBar('Failed to geo-tag display. Please try again.');
      }
    } catch (e) {
      print('Error geo-tagging display: $e');
      _showSnackBar('Error geo-tagging display. Please try again.');
    }
  }

  Future<void> _selectLocation() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => ExploreDisplayOnMap(
          initialLocation: _selectedLocation,
        ),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        _selectedLocation = selectedLocation;
        _fetchAddress(selectedLocation);
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
      print('Error fetching address: $e');
      setState(() {
        _selectedAddress = 'Address not found';
      });
    }
  }

  void _removeMedia(int index) async {
    final mediaFile = _mediaFiles[index];

    try {
      final success = await _displayService.deleteDisplayFile(
          mediaFile.displayId, mediaFile.filename);

      if (success) {
        setState(() {
          if (mediaFile.mediaType == MediaType.video) {
            _videoControllers[index].dispose();
            _videoControllers.removeAt(index);
          }
          _mediaFiles.removeAt(index);
        });
      } else {
        _showSnackBar('Failed to remove media.');
      }
    } catch (e) {
      print('Error removing media: $e');
      _showSnackBar('Error removing media. Please try again.');
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Display'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: _selectLocation,
          ),
        ],
      ),
      body: Padding(
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

              // Show location card if a location is selected
              if (_selectedLocation != null)
                Card(
                  margin: EdgeInsets.only(bottom: 16.0),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 150,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _selectedLocation!,
                          zoom: 14,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId('selected-location'),
                            position: _selectedLocation!,
                          ),
                        },
                        myLocationEnabled: false,
                        zoomControlsEnabled: false,
                      ),
                    ),
                  ),
                ),

              // Display the address of the selected location
              if (_selectedAddress != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _selectedAddress!,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),

              // Media files display
              if (_mediaFiles.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _mediaFiles.length,
                    itemBuilder: (context, index) {
                      final mediaFile = _mediaFiles[index];
                      return FadeInUp(
                        duration: Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8.0,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: _buildMediaWidget(mediaFile, index),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Tooltip(
                                  message: 'Delete',
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black54,
                                    radius: 14,
                                    child: IconButton(
                                      icon: Icon(Icons.delete,
                                          color: Colors.white, size: 16),
                                      onPressed: () => _removeMedia(index),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                Center(
                  child: Text(
                    'No media uploaded yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

              SizedBox(height: 16),
              Center(
                child: _isUploading
                    ? CircularProgressIndicator()
                    : FloatingActionButton(
                        onPressed: _pickMedia,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Icon(Icons.add, size: 30),
                      ),
              ),
              SizedBox(height: 20),

              // Button for geo-tagging
              ElevatedButton(
                onPressed: _geoTagDisplay,
                child: Text('Geo-tag Display'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaWidget(DisplayMediaFile mediaFile, int index) {
    switch (mediaFile.mediaType) {
      case MediaType.image:
        return Image.file(
          mediaFile.file,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        );
      case MediaType.video:
        return AspectRatio(
          aspectRatio: _videoControllers[index].value.aspectRatio,
          child: VideoPlayer(_videoControllers[index]),
        );
      default:
        return Container();
    }
  }
}
