import 'package:flutter/material.dart';
import 'package:myboard/screens/board/view_board_details.dart';
import 'package:myboard/screens/home/home_screen.dart';
import '../../models/board/board.dart';
import '../../repository/board_repository.dart';
import '../widgets/media_file_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ViewBoardsWidget extends StatefulWidget {
  @override
  _ViewBoardsWidgetState createState() => _ViewBoardsWidgetState();
}

class _ViewBoardsWidgetState extends State<ViewBoardsWidget> {
  late final BoardService _boardService;
  List<Board> _boards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    _boardService = BoardService(context);
    await _fetchBoards();
  }

  Future<void> _fetchBoards() async {
    try {
      final boards = await _boardService.getBoards();
      setState(() {
        _boards = boards ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching boards: $e');
    }
  }

  void _navigateToBoardDetails(Board board) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewBoardDetailsWidget(board: board),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Boards'),
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
          : _buildBoardList(),
    );
  }

  Widget _buildBoardList() {
    if (_boards.isEmpty) {
      return const Center(child: Text('No boards found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _boards.length,
      itemBuilder: (context, index) {
        final board = _boards[index];
        return GestureDetector(
          onTap: () => _navigateToBoardDetails(board),
          child: _buildBoardCard(board),
        );
      },
    );
  }

  Widget _buildBoardCard(Board board) {
    return Card(
      color: Theme.of(context).primaryColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carousel for Board media
          _buildMediaCarousel(board),
          // Board details
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  board.boardName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                ),
                const SizedBox(height: 5),
                _buildStatusIndicator(board.status),
                const SizedBox(height: 5),
                Text(
                  'Created on: ${_formatDate(board.createdDateAndTime)}',
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
    );
  }

  // Media carousel for board
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
              return MediaFileWidget(mediaFile: mediaFile); // Use MediaFileWidget
            },
          ),
        ),
        const SizedBox(height: 8), // Spacing between carousel and dot indicator
        SmoothPageIndicator(
          controller: _pageController,
          count: board.mediaFiles.length,
          effect: const WormEffect(
            dotHeight: 8.0,
            dotWidth: 8.0,
            activeDotColor: Colors.blueAccent, // Customize this color to fit your theme
          ),
        ),
      ],
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

  String _formatDate(DateTime dateTime) {
    return dateTime.toLocal().toString().split(' ')[0];
  }
}
