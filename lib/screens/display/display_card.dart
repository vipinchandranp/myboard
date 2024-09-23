import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../models/display/bdisplay.dart';
import '../../widgets/bottom_tools_widget.dart';
import '../../widgets/round_button.dart';
import '../widgets/media_file_widget.dart';
import '../../utils/utility.dart';

class DisplayCardWidget extends StatelessWidget {
  final BDisplay display;

  const DisplayCardWidget({Key? key, required this.display}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Theme.of(context).cardColor,
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
                _buildMediaCarousel(display),
                const SizedBox(height: 12),
                _buildMap(display),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        display.displayName,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildStatusIndicator(display.status, context),
                      const SizedBox(height: 6),
                      Text(
                        'Created on: ${Utility.formatDate(display.createdDateAndTime)}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 12),
                      _buildActionIcons(),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.settings, color: Colors.grey),
                onPressed: () => _showBottomSheet(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaCarousel(BDisplay display) {
    final PageController _pageController = PageController();

    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12))
          ),
          child: PageView.builder(
            controller: _pageController,
            itemCount: display.mediaFiles.length,
            itemBuilder: (context, index) {
              final mediaFile = display.mediaFiles[index];
              return MediaFileWidget(mediaFile: mediaFile);
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
      return Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12)
        ),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(display.latitude!, display.longitude!),
            zoom: 14,
          ),
          markers: {
            Marker(
              markerId: MarkerId('display-location'),
              position: LatLng(display.latitude!, display.longitude!),
            ),
          },
          myLocationEnabled: false,
          zoomControlsEnabled: false,
        ),
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

  Widget _buildActionIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
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
              icon: Icons.book,
              label: "Book to Display",
              onPressed: () {
                Navigator.pop(context);
                print("Book to Display pressed");
              },
            ),
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
          ],
        );
      },
    );
  }
}
