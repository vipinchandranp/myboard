import 'package:flutter/material.dart';
import 'package:myboard/widgets/round_button.dart';
import 'package:myboard/widgets/bottom_tools_widget.dart';
import '../../models/board/board.dart';
import '../widgets/media_file_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../utils/utility.dart'; // Import your utility file

class BoardCardWidget extends StatelessWidget {
  final Board board;
  final bool isSelected;
  final ValueChanged<bool?>? onChanged; // Callback for checkbox state change

  const BoardCardWidget({
    Key? key,
    required this.board,
    this.isSelected = false,
    this.onChanged, // Optional callback for checkbox
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
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
                _buildMediaCarousel(board),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        board.boardName,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                      ),
                      const SizedBox(height: 5),
                      _buildStatusIndicator(board.status, context),
                      const SizedBox(height: 5),
                      Text(
                        'Created on: ${Utility.formatDate(board.createdDateAndTime)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildActionIcons(),
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
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.settings, color: Colors.black),
                  onPressed: () => _showBottomSheet(context),
                )),
            Positioned(
              top: 10,
              left: 10,
              child: Checkbox(
                checkColor: Colors.white,
                value: isSelected,
                onChanged: onChanged,
                // Trigger callback when checkbox is toggled
                activeColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
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
              icon: Icons.upload,
              label: "Upload to Display",
              onPressed: () {
                Navigator.pop(context);
                print("Upload to Display pressed");
              },
            ),
            RoundedButton(
              icon: Icons.bar_chart,
              label: "Reports",
              onPressed: () {
                Navigator.pop(context);
                print("Reports pressed");
              },
            ),
            RoundedButton(
              icon: Icons.delete,
              label: "Delete Board",
              onPressed: () {
                Navigator.pop(context);
                print("Delete Board pressed");
              },
            ),
          ],
        );
      },
    );
  }
}
