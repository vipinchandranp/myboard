import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package
import 'package:myboard/screens/board/board_card.dart';
import '../../models/board/board.dart';
import '../../repository/board_repository.dart';
import '../../utils/view_mode.dart';
import '../common/filter/filter_data.dart';
import '../common/filter/filter_widget.dart';

class ViewBoardsWidget extends StatefulWidget {
  final ViewMode viewMode;
  final List<String>? boardIds; // Optional parameter for board IDs

  const ViewBoardsWidget({
    Key? key,
    this.viewMode = ViewMode.view, // Default to ViewMode.view
    this.boardIds, // Initialize board IDs if passed
  }) : super(key: key);

  @override
  _ViewBoardsWidgetState createState() => _ViewBoardsWidgetState();
}

class _ViewBoardsWidgetState extends State<ViewBoardsWidget> {
  late final BoardService _boardService;
  List<Board> _boards = [];
  bool _isLoading = true;
  bool _isFilterVisible = false; // Start with filter collapsed
  Board? _singleSelectedBoard; // Track the selected board
  final _filterWidgetKey =
      GlobalKey<FilterWidgetState>(); // Key to access filter state
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

// Fetch boards by IDs or with filters if IDs are not provided
  Future<void> _fetchBoards() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Retrieve filter data from the FilterWidget if available
      final filterMap = _filterWidgetKey.currentState?.getFilterData();

      // Create a FilterData instance, incorporating `ids` if available
      final filterData = FilterData(
        ids: widget.boardIds,
        // Use boardIds if provided
        searchText: filterMap?['searchText'],
        startDate: filterMap?['startDate'],
        endDate: filterMap?['endDate'],
        sortBy: filterMap?['sortBy'],
      );

      // Fetch boards using the combined filterData
      final boards = await _boardService.getBoards(filterData);
      setState(() {
        _boards = boards ?? [];
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching boards: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Handle board selection
  void _handleBoardSelection(Board board) {
    setState(() {
      _singleSelectedBoard = _singleSelectedBoard == board ? null : board;
    });
    Navigator.pop(context, _singleSelectedBoard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Boards'),
        backgroundColor: Theme.of(context).cardColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _singleSelectedBoard);
          },
        ),
      ),
      body: Column(
        children: [
          // Expandable Filter Section
          ExpansionTile(
            title: const Text("Filter"),
            leading: Icon(Icons.filter),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (_isFilterVisible)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        height: _isFilterVisible ? 400 : 0,
                      ),
                    // Display filter widget
                    FilterWidget(
                      key: _filterWidgetKey,
                      onApplyFilter: (filterData) {
                        setState(() {
                          _fetchBoards();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: _isLoading
                ? _buildShimmerEffect() // Display shimmer effect when loading
                : _boards.isEmpty
                    ? const Center(child: Text('No boards available.'))
                    : ListView.builder(
                        itemCount: _boards.length,
                        itemBuilder: (context, index) {
                          final board = _boards[index];
                          return BoardCardWidget(
                            board: board,
                            isSelected: board == _singleSelectedBoard,
                            onSelect: widget.viewMode ==
                                    ViewMode.timeslotBoardSelection
                                ? () => _handleBoardSelection(board)
                                : null,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // Shimmer effect for loading state
  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5, // Number of shimmer items (adjust as needed)
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        );
      },
    );
  }
}
