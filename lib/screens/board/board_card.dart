import 'package:flutter/material.dart';
import '../../models/board/board.dart';
import '../../types/notification_type.dart';
import '../notification/notification_card.dart';
import '../widgets/media_file_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../utils/utility.dart';

class BoardCardWidget extends StatefulWidget {
  final Board board;
  final bool isSelected;
  final VoidCallback? onSelect; // A callback to handle board selection

  const BoardCardWidget({
    Key? key,
    required this.board,
    this.isSelected = false,
    this.onSelect, // Include the onSelect callback
  }) : super(key: key);

  @override
  _BoardCardWidgetState createState() => _BoardCardWidgetState();
}

class _BoardCardWidgetState extends State<BoardCardWidget> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildMediaCarousel(widget.board),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.board.boardName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Add a checkbox for selection (only when callback is provided)
          if (widget.onSelect != null)
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                shape: const CircleBorder(),
                checkColor: Colors.white,
                activeColor: Colors.blueAccent,
                value: isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    isSelected = value ?? false;
                  });
                  widget.onSelect?.call(); // Trigger the selection callback
                },
              ),
            ),
          // More options button
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showBottomSheet(context),
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
          height: 200,
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

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () {
                  print("Edit pressed");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {
                  print("Delete pressed");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.display_settings),
                title: Text('Select Display'),
                onTap: () {
                  print("Select Display pressed");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
