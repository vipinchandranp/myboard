import 'package:flutter/material.dart';
import 'package:myboard/screens/home/home_screen.dart';
import 'package:shimmer/shimmer.dart'; // Import Shimmer package
import '../../models/display/bdisplay.dart';
import '../../models/display/display_filter.dart';
import '../../repository/display_repository.dart';
import '../widgets/filter_widget.dart'; // Import the FilterWidget
import 'display_card.dart';
import '../../themes/app_theme.dart'; // Import your AppTheme

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
      final displayFilter = DisplayFilter(
        searchText: _searchText,
        dateRange: _dateRange,
        status: _selectedStatus,
        isRecent: _isRecent,
        isFavorite: _isFavorite,
      );

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
      ),
      body: SingleChildScrollView(
        // Wrap the entire body with SingleChildScrollView
        child: Container(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          // Set the background color
          child: Column(
            children: [
              _buildFilterToolbar(), // Custom filter toolbar
              if (_isFilterVisible)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  height: _isFilterVisible ? 400 : 0,
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
              _isLoading
                  ? _buildShimmerEffect() // Use Shimmer effect here
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : _buildDisplayPageView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterToolbar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            TextButton.icon(
              onPressed: () {
                // Handle Sort functionality
              },
              icon: Icon(Icons.sort, color: Colors.black),
              // Changed to black for visibility
              label: Text(
                'Sort By (Rating)',
                style: TextStyle(color: Colors.black), // Changed to black
              ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _isFilterVisible = !_isFilterVisible;
                });
              },
              icon: Icon(Icons.filter_alt, color: Colors.black),
              // Changed to black for visibility
              label: Text(
                'All Filters',
                style: TextStyle(color: Colors.black), // Changed to black
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // Handle additional filter functionality
              },
              icon: Icon(Icons.star, color: Colors.black),
              // Changed to black for visibility
              label: Text(
                'Star Rating',
                style: TextStyle(color: Colors.black), // Changed to black
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      shrinkWrap: true, // Adjust height to prevent overflow
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // You can adjust the number of shimmer placeholders
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

  Widget _buildDisplayPageView() {
    if (_displays.isEmpty) {
      return const Center(child: Text('No displays found.'));
    }

    return ListView.separated(
      shrinkWrap: true,
      // Adjust height to prevent overflow
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _displays.length,
      itemBuilder: (context, index) {
        final display = _displays[index];
        return GestureDetector(
          onTap: () {
            // Optionally handle tap events on the display card
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: DisplayCardWidget(display: display),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey, // You can adjust the color of the divider
        thickness: 1, // Adjust the thickness of the divider
      ),
    );
  }
}
