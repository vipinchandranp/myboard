import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myboard/bloc/display/display_cubit.dart';
import 'package:myboard/bloc/display/display_state.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/screens/display_info_screen.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late DisplayCubit displayCubit;
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    displayCubit = BlocProvider.of<DisplayCubit>(context);
    // Fetch the list of all displays when the screen is initialized
    displayCubit.getAllDisplays();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DisplayCubit, DisplayState>(
        builder: (context, state) {
          if (state is DisplayLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is DisplayLoaded) {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0), // Set the initial map center
                zoom: 2.0, // Set the initial zoom level
              ),
              markers: _getMarkers(state.displays),
            );
          } else if (state is DisplayError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Set<Marker> _getMarkers(List<DisplayDetails> displays) {
    Set<Marker> markers = Set();

    for (DisplayDetails displayDetails in displays) {
      if (displayDetails.latitude != null && displayDetails.longitude != null) {
        markers.add(Marker(
          markerId: MarkerId(displayDetails.id),
          position: LatLng(displayDetails.latitude, displayDetails.longitude),
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
        return DisplayDetailsPopup(displayDetails: displayDetails);
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
}
