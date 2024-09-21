import 'package:flutter/material.dart';
import 'package:myboard/screens/display/view_display_details.dart';
import 'package:myboard/screens/home/home_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../models/display/display_media_file.dart';
import '../../repository/display_repository.dart';
import '../../models/display/bdisplay.dart';
import '../widgets/media_file_widget.dart';

class ViewDisplayWidget extends StatefulWidget {
  @override
  _ViewDisplaysWidgetState createState() => _ViewDisplaysWidgetState();
}

class _ViewDisplaysWidgetState extends State<ViewDisplayWidget> {
  List<BDisplay> _displays = [];
  bool _isLoading = true;

  late DisplayService _displayService;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    _displayService = DisplayService(context);
    await _fetchDisplays();
  }

  Future<void> _fetchDisplays() async {
    try {
      final displays = await _displayService.getDisplays();
      setState(() {
        _displays = displays ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching displays: $e');
    }
  }

  void _navigateToDisplayDetails(BDisplay display) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewDisplayDetailsWidget(display: display),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Displays'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _displays.isEmpty
              ? const Center(child: Text('No displays found.'))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _displays.length,
                      itemBuilder: (context, index) {
                        final display = _displays[index];
                        return GestureDetector(
                          onTap: () => _navigateToDisplayDetails(display),
                          child: _buildDisplayCard(display, constraints),
                        );
                      },
                    );
                  },
                ),
    );
  }

  Widget _buildDisplayCard(BDisplay display, BoxConstraints constraints) {
    final PageController _pageController = PageController();

    return Card(
      color: Theme.of(context).primaryColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: constraints.maxHeight * 0.5, // Occupies half the screen height
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media carousel with dot navigation
            Expanded(
              child: Column(
                children: [
                  Expanded(
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
              ),
            ),
            // Display details at the bottom
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    display.displayName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 5),
                  _buildStatusIndicator(display.status),
                  const SizedBox(height: 5),
                  Text(
                    'Created on: ${display.createdDateAndTime.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.thumb_up_alt_outlined, color: Colors.grey),
                      Icon(Icons.comment_outlined, color: Colors.grey),
                      Icon(Icons.share_outlined, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
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

  // Helper method to get color based on status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return Colors.green;
      case 'WAITING_FOR_APPROVAL':
        return Colors.orange;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
