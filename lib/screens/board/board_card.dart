import 'package:flutter/material.dart';
import '../../models/board/board.dart';
import '../widgets/media_file_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../utils/utility.dart'; // Import your utility file

class BoardCardWidget extends StatefulWidget {
  final Board board;
  final bool isSelected; // Keep initial selection passed from parent

  const BoardCardWidget({
    Key? key,
    required this.board,
    this.isSelected = false, // Default to false if not provided
  }) : super(key: key);

  @override
  _BoardCardWidgetState createState() => _BoardCardWidgetState();
}

class _BoardCardWidgetState extends State<BoardCardWidget> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected; // Initialize state from parent
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMediaCarousel(widget.board),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.board.boardName,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                    ),
                    const SizedBox(height: 5),
                    _buildStatusIndicator(widget.board.status, context),
                    const SizedBox(height: 5),
                    Text(
                      'Created on: ${Utility.formatDate(widget.board.createdDateAndTime)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildActionIcons(),
                    const SizedBox(height: 10),
                    _buildBottomButtons(), // Add the buttons here
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Checkbox(
              checkColor: Colors.white,
              value: isSelected,
              activeColor: Colors.blueAccent,
              onChanged: (bool? value) {
                setState(() {
                  isSelected = value ?? false; // Toggle selection
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaCarousel(Board board) {
    final PageController _pageController = PageController();

    return Column(
      children: [
        Container(
          height: 200, // Adjust the height as necessary
          child: PageView.builder(
            controller: _pageController,
            itemCount: board.mediaFiles.length,
            itemBuilder: (context, index) {
              final mediaFile = board.mediaFiles[index];
              return MediaFileWidget(mediaFile: mediaFile);
            },
          ),
        ),
        const SizedBox(height: 8),
        SmoothPageIndicator(
          controller: _pageController,
          count: board.mediaFiles.length,
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

  Widget _buildActionIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Icon(Icons.thumb_up_alt_outlined, color: Colors.grey),
        Icon(Icons.comment_outlined, color: Colors.grey),
        Icon(Icons.share_outlined, color: Colors.grey),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSmallRoundedButton(
          icon: Icons.upload,
          label: "Upload",
          onPressed: () {
            print("Upload to Display pressed");
          },
        ),
        _buildSmallRoundedButton(
          icon: Icons.bar_chart,
          label: "Reports",
          onPressed: () {
            print("Reports pressed");
          },
        ),
        _buildSmallRoundedButton(
          icon: Icons.delete,
          label: "Delete",
          onPressed: () {
            print("Delete Board pressed");
          },
        ),
      ],
    );
  }

  Widget _buildSmallRoundedButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          color: Colors.black,
          iconSize: 20, // Smaller icon size
          onPressed: onPressed,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12, // Smaller text size
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
