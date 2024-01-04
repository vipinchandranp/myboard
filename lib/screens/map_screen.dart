import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myboard/models/display_details.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late List<DisplayDetails> displayDetailsList;
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Generate random display details for testing
    displayDetailsList =
        List.generate(5, (index) => DisplayDetails.fromDateTimeSlot());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0), // Set the initial map center
          zoom: 2.0, // Set the initial zoom level
        ),
        markers: _getMarkers(),
      ),
    );
  }

  Set<Marker> _getMarkers() {
    Set<Marker> markers = Set();

    for (DisplayDetails displayDetails in displayDetailsList) {
      if (displayDetails.latitude != null &&
          displayDetails.longitude != null) {
        markers.add(Marker(
          markerId: MarkerId(displayDetails.id),
          position:
          LatLng(displayDetails.latitude, displayDetails.longitude),
          onTap: () {
            _showInfoWindow(context, displayDetails);
          },
        ));
      }
    }

    return markers;
  }

  void _showInfoWindow(BuildContext context, DisplayDetails displayDetails) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height * 0.75,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayDetails.id ?? 'ID',
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    displayDetails.description ?? 'Description',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Rating: ${displayDetails.rating.toStringAsFixed(1)}/5',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: false,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentImageIndex = index;
                        });
                      },
                    ),
                    items: _buildImageList(displayDetails.images),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Comments:',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildCommentsList(displayDetails.comments),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommentsList(List<Comment> comments) {
    return Column(
      children: comments
          .map(
            (comment) => Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${comment.username} - ${comment.date.toLocal()}',
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                comment.text,
                style: TextStyle(fontSize: 14),
              ),
              _buildRepliesList(comment.replies),
            ],
          ),
        ),
      )
          .toList(),
    );
  }

  Widget _buildRepliesList(List<Reply> replies) {
    return replies.isNotEmpty
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: replies
          .map(
            (reply) => Container(
          margin: EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${reply.username} - ${reply.date.toLocal()}',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                reply.text,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      )
          .toList(),
    )
        : SizedBox.shrink();
  }

  List<Widget> _buildImageList(List<XFile>? imageFiles) {
    List<Widget> imageWidgets = [];

    if (imageFiles != null) {
      // You can customize the image loading logic here
      for (XFile imageFile in imageFiles) {
        // Use Image.network for Flutter web
        imageWidgets.add(
          kIsWeb
              ? Image.network(
            imageFile.path,
            fit: BoxFit.cover,
          )
              : Image.file(
            File(imageFile.path),
            fit: BoxFit.cover,
          ),
        );
      }
    }

    return imageWidgets;
  }

  void _handleKeyPress(RawKeyEvent event, int maxImages) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _navigateImage(-1, maxImages);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _navigateImage(1, maxImages);
      }
    }
  }

  void _navigateImage(int direction, int maxImages) {
    int newIndex = currentImageIndex + direction;
    if (newIndex >= 0 && newIndex < maxImages) {
      setState(() {
        currentImageIndex = newIndex;
      });
    }
  }
}
