import 'package:flutter/material.dart';
import 'package:myboard/screens/home/home_screen.dart';
import '../../models/display/bdisplay.dart';
import '../../models/display/display_filter.dart';
import '../../repository/display_repository.dart';
import '../widgets/filter_widget.dart'; // Import the FilterWidget
import 'display_card.dart';

class ViewDisplayWidget extends StatefulWidget {
  @override
  _ViewDisplaysWidgetState createState() => _ViewDisplaysWidgetState();
}

class _ViewDisplaysWidgetState extends State<ViewDisplayWidget> {
  List<BDisplay> _displays = [];
  bool _isLoading = true;
  bool _isFilterVisible = false; // Filter visibility control

  late DisplayService _displayService;

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
    _displayService = DisplayService(context);
    await _fetchDisplays();
  }
  Future<void> _fetchDisplays() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Create an instance of DisplayFilter with the required parameters
      final displayFilter = DisplayFilter(
        searchText: _searchText,
        dateRange: _dateRange,
        status: _selectedStatus,
        isRecent: _isRecent,
        isFavorite: _isFavorite,
      );

      // Fetch displays using the display filter
      final displays = await _displayService.getDisplays(displayFilter);

      setState(() {
        _displays = displays ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching displays: $e';
      });
    }
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
              MaterialPageRoute(builder: (context) => HomeScreen(context)),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFilterVisible ? Icons.expand_less : Icons.expand_more,
            ),
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
          // Filter section
          if (_isFilterVisible)
            SingleChildScrollView(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                height: _isFilterVisible ? 400 : 0, // Fixed height for filter
                child: FilterWidget(
                  suggestions: ['Display 1', 'Display 2', 'Display 3'],
                  onSearchChanged: (value) {
                    setState(() {
                      _searchText = value;
                      _fetchDisplays();
                    });
                  },
                  dateRange: _dateRange,
                  onDateRangeChanged: (value) {
                    setState(() {
                      _dateRange = value;
                      _fetchDisplays();
                    });
                  },
                  selectedStatus: _selectedStatus,
                  onStatusChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                      _fetchDisplays();
                    });
                  },
                  isRecent: _isRecent,
                  onRecentToggle: (value) {
                    setState(() {
                      _isRecent = value;
                      _fetchDisplays();
                    });
                  },
                  isFavorite: _isFavorite,
                  onFavoriteToggle: (value) {
                    setState(() {
                      _isFavorite = value;
                      _fetchDisplays();
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
                    : _buildDisplayList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayList() {
    if (_displays.isEmpty) {
      return const Center(child: Text('No displays found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _displays.length,
      itemBuilder: (context, index) {
        final display = _displays[index];
        return GestureDetector(
          child: DisplayCardWidget(display: display),
        );
      },
    );
  }
}
