import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myboard/screens/board/view_boards.dart';
import 'package:myboard/screens/display/timeslots.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../models/board/board.dart'; // This import can be removed if you're no longer using the Board model directly
import '../../models/display/bdisplay.dart';
import '../../widgets/bottom_tools_widget.dart';
import '../../widgets/round_button.dart';
import '../../utils/utility.dart';
import 'board_listview.dart';

class DisplayCardWidget extends StatefulWidget {
  final BDisplay display;

  const DisplayCardWidget({Key? key, required this.display}) : super(key: key);

  @override
  _DisplayCardWidgetState createState() => _DisplayCardWidgetState();
}

class _DisplayCardWidgetState extends State<DisplayCardWidget> {
  bool _isMapExpanded = false; // Track if the map is expanded

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle any general tap gestures if needed
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMap(widget.display),
                const SizedBox(height: 12),
                _buildMediaCarousel(widget.display),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.display.displayName,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 6),
                      _buildStatusIndicator(widget.display.status, context),
                      const SizedBox(height: 6),
                      Text(
                        'Created on: ${Utility.formatDate(widget.display.createdDateAndTime)}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 12),
                      _buildActionIcons(),
                      const SizedBox(height: 12),
                      _buildBoardList(widget.display.boardIds), // Pass boardIds
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: FloatingActionButton(
                mini: true,
                heroTag: "settings",
                backgroundColor: Colors.white,
                child: const Icon(Icons.settings, color: Colors.black),
                onPressed: () => _showBottomSheet(context),
              ),
            ),
            if (_isMapExpanded)
              Positioned.fill(
                child: _buildFullScreenMap(widget.display),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoardList(List<String> boardIds) {
    if (boardIds.isEmpty) {
      return const Text(
        'No boards associated with this display.',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            // Navigate to a detailed board view or perform another action here
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewBoardsWidget(boardIds: boardIds),
              ),
            );
          },
          child: Text(
            '${boardIds.length} boards associated',
            style: TextStyle(
              color: Colors.blue, // Change color for better visibility
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaCarousel(BDisplay display) {
    final PageController _pageController = PageController();

    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: PageView.builder(
            controller: _pageController,
            itemCount: display.mediaFiles.length,
            itemBuilder: (context, index) {
              final mediaFile = display.mediaFiles[index];
              return CachedNetworkImage(
                imageUrl: mediaFile.filename,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        SmoothPageIndicator(
          controller: _pageController,
          count: display.mediaFiles.length,
          effect: const WormEffect(
            dotHeight: 8.0,
            dotWidth: 8.0,
            activeDotColor: Colors.blueAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(String status, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Utility.getStatusColor(status),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMap(BDisplay display) {
    if (display.latitude != null && display.longitude != null) {
      return Stack(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(display.latitude!, display.longitude!),
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('display-location'),
                  position: LatLng(display.latitude!, display.longitude!),
                ),
              },
              myLocationEnabled: false,
              zoomControlsEnabled: false,
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: FloatingActionButton(
              mini: true,
              heroTag: "map_back",
              backgroundColor: Colors.white,
              child: const Icon(Icons.map, color: Colors.black),
              onPressed: () {
                setState(() {
                  _isMapExpanded = true; // Expand the map on button press
                });
              },
            ),
          ),
        ],
      );
    } else {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          'Location not available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
  }

  Widget _buildFullScreenMap(BDisplay display) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(display.latitude!, display.longitude!),
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('display-location'),
                position: LatLng(display.latitude!, display.longitude!),
              ),
            },
            myLocationEnabled: false,
            zoomControlsEnabled: true,
          ),
          Positioned(
            top: 40,
            left: 16,
            child: FloatingActionButton(
              mini: true,
              heroTag: "map_expand",
              backgroundColor: Colors.white,
              child: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                setState(() {
                  _isMapExpanded =
                      false; // Collapse the map on back button press
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(Icons.thumb_up_alt_outlined, color: Colors.grey),
        Icon(Icons.comment_outlined, color: Colors.grey),
        Icon(Icons.share_outlined, color: Colors.grey),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return BottomToolsWidget(
          buttons: [
            RoundedButton(
              icon: Icons.bar_chart,
              label: "Performance",
              onPressed: () {
                Navigator.pop(context);
                print("Performance pressed");
              },
            ),
            RoundedButton(
              icon: Icons.delete,
              label: "Delete Display",
              onPressed: () {
                Navigator.pop(context);
                print("Delete Display pressed");
              },
            ),
            RoundedButton(
              icon: Icons.access_time,
              label: "Book Display",
              onPressed: () async {
                Navigator.pop(context);

                // Show TimeSlotWidget as a bottom sheet
                final selectedTimeSlots = await showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return TimeSlotWidget(
                        displayId: widget.display.displayId,
                        parentContext: context);
                  },
                );
                setState(() {
                  
                });
              },
            ),
          ],
        );
      },
    );
  }
}
