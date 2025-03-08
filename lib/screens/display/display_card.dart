import 'package:flutter/material.dart';
import 'package:myboard/repository/display_repository.dart';
import 'package:myboard/screens/common/status/status_button.dart';
import 'package:myboard/screens/display/stepper_screen.dart';
import 'package:myboard/models/display/bdisplay.dart';
import 'package:myboard/screens/display/media_carousel.dart';
import 'package:myboard/utils/utility.dart';
import 'package:myboard/widgets/round_button.dart';
import '../../utils/ItemType.dart';
import '../common/comments_interaction_widget.dart';
import '../common/like_dislike_widget.dart';
import '../common/show_ratings_star.dart';
import '../qrcode/show_qr_code.dart';
import 'associated_boards_screen.dart';
import 'create_display.dart';
import 'current_board_playing.dart';

class DisplayCardWidget extends StatelessWidget {
  final BDisplay display;

  const DisplayCardWidget({Key? key, required this.display}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme, context),
          MediaCarouselWidget(display: display),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                // Status Button Integration
                StatusButton(status: display.status),

                const SizedBox(height: 6),
                Text(
                  'Created on: ${Utility.formatDate(display.createdDateAndTime)}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),

                // Add the price in a large font with Indian Rupee symbol
                if (display.price != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Price: ₹${display.price!.toStringAsFixed(2)} / hour',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Add the displayPin here in a large font
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Pin: ${display.displayPin}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Board List Section
                AssociatedBoardsScreen(displayId: display.displayId),


                const SizedBox(height: 10),


                ShowRatingStarsWidget(  // Display rating stars here
                  contentId: display.displayId,
                  contentType: ItemType.DISPLAY,
                ),

                const SizedBox(height: 16),

                // Add Like and Dislike Buttons here
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LikeDislikeWidget(
                      contentId: display.displayId,
                      contentType: ItemType.DISPLAY,
                      initialLikes: display.numberOfLikes,
                      initialDislikes: display.numberOfDislikes,
                      initiallyLiked: display.likedByCurrentUser,
                      initiallyDisliked: display.dislikedByCurrentUser,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Horizontally scrollable buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      RoundedButton(
                        icon: Icons.book_online,
                        label: 'Book Display',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StepperScreen(display: display),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      RoundedButton(
                        icon: Icons.qr_code,
                        label: 'Show QR Code',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowQRCode(
                                data: display.displayId,
                                title: 'QR Code for ${display.displayName}',
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      RoundedButton(
                        icon: Icons.play_arrow,
                        label: 'Show Currently Playing',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CurrentBoardPlaying(
                                displayId: display.displayId,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      RoundedButton(
                        icon: Icons.reviews,
                        label: 'Reviews',
                        onPressed: () => _showCommentsInteraction(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      color: theme.colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              display.displayName,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.colorScheme.onPrimary),
            onPressed: () => _showBottomSheet(context),
          ),
        ],
      ),
    );
  }
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to CreateDisplayWidget in edit mode, passing displayId.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateDisplayWidget(displayId: display.displayId),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete'),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmationDialog(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this display?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                await new DisplayService(context).deleteDisplay(display.displayId);
                print('Display deleted');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Display deleted successfully')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }



  void _showCommentsInteraction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return CommentsInteractionWidget(
              contentId: display.displayId,
              contentType: ItemType.DISPLAY,
            );
          },
        );
      },
    );
  }
}
