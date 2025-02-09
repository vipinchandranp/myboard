import 'package:flutter/material.dart';
import '../../models/board/board.dart';
import '../../themes/app_theme.dart';
import '../../utils/content_type.dart';
import '../../widgets/round_button.dart';
import '../common/AddRatingWidget.dart';
import '../common/comments_interaction_widget.dart';
import '../common/like_dislike_widget.dart';
import '../common/show_ratings_star.dart'; // Importing the ShowRatingStarsWidget
import '../common/status/status_button.dart';
import '../widgets/media_file_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../utils/utility.dart';

class BoardCardWidget extends StatefulWidget {
  final Board board;
  final bool isSelected;
  final VoidCallback? onSelect;

  const BoardCardWidget({
    Key? key,
    required this.board,
    this.isSelected = false,
    this.onSelect,
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
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: widget.onSelect != null
          ? () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onSelect?.call();
      }
          : null,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? AppTheme.secondaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            _buildMediaCarousel(widget.board),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  StatusButton(status: widget.board.status),
                  const SizedBox(height: 5),
                  Text(
                    'Created on: ${Utility.formatDate(widget.board.createdDateAndTime)}',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ShowRatingStarsWidget(  // Display rating stars here
                    contentId: widget.board.boardId,
                    contentType: MBContentType.BOARD,
                  ),
                  const SizedBox(height: 10),
                  _buildActionIcons(),
                  const SizedBox(height: 10),
                  LikeDislikeWidget(
                    contentId: widget.board.boardId,
                    contentType: MBContentType.BOARD,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      color: theme.colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                widget.board.boardName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 10),
              if (widget.onSelect != null)
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    shape: const CircleBorder(),
                    checkColor: theme.colorScheme.onPrimary,
                    activeColor: theme.colorScheme.primaryContainer,
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        isSelected = value ?? false;
                      });
                      widget.onSelect?.call();
                    },
                  ),
                ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.colorScheme.onPrimary),
            onPressed: () => _showBottomSheet(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaCarousel(Board board) {
    final PageController pageController = PageController();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: pageController,
            itemCount: board.mediaFiles.length,
            itemBuilder: (context, index) {
              final mediaFile = board.mediaFiles[index];
              return MediaFileWidget(mediaFile: mediaFile);
            },
          ),
        ),
        const SizedBox(height: 8),
        SmoothPageIndicator(
          controller: pageController,
          count: board.mediaFiles.length,
          effect: WormEffect(
            dotHeight: 8.0,
            dotWidth: 8.0,
            activeDotColor: AppTheme.secondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActionIcons() {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RoundedButton(
          icon: Icons.comment,
          label: 'Comments',
          onPressed: () => _showCommentsInteraction(context),
        ),
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
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  print("Edit pressed");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  print("Delete pressed");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.display_settings),
                title: const Text('Select Display'),
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
              contentId: widget.board.boardId,
              contentType: MBContentType.BOARD,
            );
          },
        );
      },
    );
  }
}
