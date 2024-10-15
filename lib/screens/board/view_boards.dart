import 'package:flutter/material.dart';
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
  List<String>? _boardIds; // Store board IDs that you might want to filter by
  bool _isLoading = true;
  bool _isFilterVisible = false; // Control filter visibility
  Set<Board> _selectedBoards = {}; // Track selected boards (can be multiple)
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
      size: 4,
      boardIds: _boardIds,
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
            // Return selected board IDs (if in timeslotBoardSelection, return only one)
            if (widget.viewMode == ViewMode.timeslotBoardSelection) {
              Navigator.pop(context, _singleSelectedBoard?.boardId);
            } else {
              Navigator.pop(context, _selectedBoards.map((board) => board.boardId).toList());
            }
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
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _buildBoardList(),
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

  Widget _buildBoardList() {
    if (_boards.isEmpty) {
      return const Center(child: Text('No boards found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _boards.length,
      itemBuilder: (context, index) {
        final board = _boards[index];
        final isSelected = _selectedBoards.contains(board);
        final isSingleSelected = _singleSelectedBoard == board;

        return GestureDetector(
          onTap: () {
            setState(() {
              if (widget.viewMode == ViewMode.timeslotBoardSelection) {
                // Allow only one selection in timeslotBoardSelection mode
                _singleSelectedBoard = board;
              } else {
                // Allow multiple selections in other modes
                if (isSelected) {
                  _selectedBoards.remove(board);
                } else {
                  _selectedBoards.add(board);
                }
              }
            });
          },
          child: BoardCardWidget(
            board: board,
            isSelected: widget.viewMode == ViewMode.timeslotBoardSelection
                ? isSingleSelected
                : isSelected,
          ),
        );
      },
    );
  }
}
