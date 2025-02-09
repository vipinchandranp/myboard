import 'package:flutter/material.dart';
import 'package:myboard/screens/home/home_screen.dart';
import 'package:shimmer/shimmer.dart'; // Import Shimmer package
import '../../models/display/bdisplay.dart';
import '../../repository/display_repository.dart';
import '../common/filter/filter_data.dart';
import 'display_card.dart';
import '../../themes/app_theme.dart'; // Import your AppTheme
import '../common/filter/filter_widget.dart'; // Import FilterWidget

class ViewDisplayWidget extends StatefulWidget {
  @override
  _ViewDisplaysWidgetState createState() => _ViewDisplaysWidgetState();
}

class _ViewDisplaysWidgetState extends State<ViewDisplayWidget> {
  List<BDisplay> _displays = [];
  bool _isLoading = true;
  bool _isFilterVisible = false; // Filter visibility control
  final GlobalKey<FilterWidgetState> _filterWidgetKey = GlobalKey<FilterWidgetState>();

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
      // Retrieve filter data from the FilterWidget
      final filterMap = _filterWidgetKey.currentState?.getFilterData();
      final filterData = filterMap != null
          ? FilterData(
        searchText: filterMap['searchText'], // Corrected the key
        startDate: filterMap['startDate'],
        endDate: filterMap['endDate'],
        sortBy: filterMap['sortBy'],
      )
          : null;

      // Fetch displays using the filter data
      final displays = await _displayService.getDisplays(filterData);

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
          color: AppTheme.lightTheme.scaffoldBackgroundColor, // Apply the theme color
          child: Column(
            children: [
              // Collapsible "Book Display" Stepper section using ExpansionTile
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
                            // Apply the filter data when the user clicks "Apply Filter"
                            setState(() {
                              _searchText = filterData['searchText'] ?? '';
                              _dateRange = DateTimeRange(
                                start: filterData['startDate'] ?? DateTime.now(),
                                end: filterData['endDate'] ?? DateTime.now(),
                              );
                              _fetchDisplays(); // Fetch filtered displays
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
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

  Widget _buildShimmerEffect() {
    return ListView.builder(
      shrinkWrap: true, // Adjust height to prevent overflow
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // You can adjust the number of shimmer placeholders
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: AppTheme.shimmerBaseColor, // Use shimmer base color from AppTheme
            highlightColor: AppTheme.shimmerHighlightColor, // Use shimmer highlight color from AppTheme
            child: Container(
              height: 120.0, // Adjust this height to match your card size
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60.0, // Shimmer placeholder for image
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 10.0, // Shimmer placeholder for title
                    width: 150.0,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 10.0, // Shimmer placeholder for description or subtitle
                    width: 100.0,
                    color: Colors.grey[300],
                  ),
                ],
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
        color: AppTheme.secondaryColor, // Use secondary color from AppTheme
        thickness: 1, // Adjust the thickness of the divider
      ),
    );
  }
}
