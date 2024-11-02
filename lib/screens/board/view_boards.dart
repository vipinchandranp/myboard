import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package
import '../../models/board/board.dart';
import '../../models/board/board_filter.dart';
import '../../repository/board_repository.dart';
import '../../utils/view_mode.dart';
import '../widgets/filter_widget.dart';
import 'board_card.dart';

class ViewBoardsWidget extends StatefulWidget {
  final ViewMode viewMode; // ViewMode added as optional

  const ViewBoardsWidget({
    Key? key,
    this.viewMode = ViewMode.view, // Default value is set to ViewMode.view
  }) : super(key: key);

  @override
  _ViewBoardsWidgetState createState() => _ViewBoardsWidgetState();
}

class _ViewBoardsWidgetState extends State<ViewBoardsWidget> {
  late final BoardService _boardService;
  List<Board> _boards = [];
  bool _isLoading = true;
  bool _isFilterVisible = false; // Control filter visibility
  Board? _singleSelectedBoard; // For ViewMode.timeslotBoardSelection, single selection

  // Filter state variables
  String _searchText = '';
  DateTimeRange? _dateRange;
  String? _selectedStatus;
  bool _isRecent = false;
  bool _isFavorite = false;
  String? _errorMessage;

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
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final filter = BoardFilter(
      page: 0,
      size: 10, // Increased size to fetch more boards
      searchText: _searchText,
      dateRange: _dateRange,
      status: _selectedStatus,
      isRecent: _isRecent,
      isFavorite: _isFavorite,
    );

    try {
      final boards = await _boardService.getBoards(filter);

      setState(() {
        _boards = boards ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching boards: $e';
      });
    }
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
            Navigator.pop(context, _singleSelectedBoard?.boardId);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_isFilterVisible ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _isFilterVisible = !_isFilterVisible;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isFilterVisible)
            SingleChildScrollView(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                height: _isFilterVisible ? 400 : 0, // Fixed height for filter
                child: FilterWidget(
                  suggestions: ['Board 1', 'Board 2', 'Board 3'],
                  onSearchChanged: (value) {
                    setState(() {
                      _searchText = value;
                      _fetchBoards();
                    });
                  },
                  dateRange: _dateRange,
                  onDateRangeChanged: (value) {
                    setState(() {
                      _dateRange = value;
                      _fetchBoards();
                    });
                  },
                  selectedStatus: _selectedStatus,
                  onStatusChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                      _fetchBoards();
                    });
                  },
                  isRecent: _isRecent,
                  onRecentToggle: (value) {
                    setState(() {
                      _isRecent = value;
                      _fetchBoards();
                    });
                  },
                  isFavorite: _isFavorite,
                  onFavoriteToggle: (value) {
                    setState(() {
                      _isFavorite = value;
                      _fetchBoards();
                    });
                  },
                ),
              ),
            ),
          Expanded(
            child: _isLoading
                ? _buildShimmerLoading() // Replace CircularProgressIndicator with shimmer
                : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _buildBoardPageView(),
          ),
          if (widget.viewMode == ViewMode.timeslotBoardSelection && _singleSelectedBoard != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _singleSelectedBoard);
                },
                child: const Text('Confirm Selection'),
              ),
            ),
        ],
      ),
    );
  }

  // Shimmer Loading Indicator Widget
  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 4, // Show 4 loading placeholders
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: double.infinity,
              height: 100.0, // Fixed height for shimmer placeholder
              color: Colors.grey[300],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBoardPageView() {
    if (_boards.isEmpty) {
      return const Center(child: Text('No boards found.'));
    }

    return PageView.builder(
      scrollDirection: Axis.vertical, // Set the scroll direction to vertical
      itemCount: _boards.length,
      itemBuilder: (context, index) {
        final board = _boards[index];

        return GestureDetector(
          onTap: () {
            setState(() {
              if (widget.viewMode == ViewMode.timeslotBoardSelection) {
                _singleSelectedBoard = board;
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: BoardCardWidget(
              board: board,
              isSelected: _singleSelectedBoard == board,
            ),
          ),
        );
      },
    );
  }
}
