import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilter;
  const FilterWidget({Key? key, required this.onApplyFilter}) : super(key: key);

  @override
  FilterWidgetState createState() => FilterWidgetState();
}

class FilterWidgetState extends State<FilterWidget> {
  final _searchController = TextEditingController();
  DateTimeRange? _dateRange;
  String? _sortBy;
  List<String> _statusFilters = []; // To store selected status filters
  final ScrollController _scrollController = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  // Retrieve the current filter settings
  Map<String, dynamic> getFilterData() {
    return {
      'searchText': _searchController.text,
      'startDate': _dateRange?.start,
      'endDate': _dateRange?.end,
      'sortBy': _sortBy,
      'statusFilters': _statusFilters, // Include selected status filters
    };
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _showLeftArrow = _scrollController.offset > 0;
      _showRightArrow = _scrollController.offset < _scrollController.position.maxScrollExtent;
    });
  }

  // Open date range picker
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: _dateRange,
    );

    if (picked != null && picked != _dateRange) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  // Clear filters and reset
  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _dateRange = null;
      _sortBy = null;
      _statusFilters.clear(); // Reset status filters
    });
    widget.onApplyFilter(getFilterData());
  }

  // Build the dropdown with checkboxes for the status filters
  Widget _buildStatusDropdown() {
    return PopupMenuButton<String>(
      onSelected: (String status) {
        setState(() {
          if (_statusFilters.contains(status)) {
            _statusFilters.remove(status);
          } else {
            _statusFilters.add(status);
          }
          widget.onApplyFilter(getFilterData());
        });
      },
      itemBuilder: (BuildContext context) {
        return [
          'Favourites',
          'Approved',
          'Rejected',
          'Waiting For Approval',
        ].map((status) {
          return CheckedPopupMenuItem<String>(
            value: status,
            checked: _statusFilters.contains(status),
            child: Text(status),
          );
        }).toList();
      },
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Select Status', style: TextStyle(color: Colors.black54)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Horizontal scrollable filter row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () => widget.onApplyFilter(getFilterData()),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: const Text('Apply Filter', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _clearFilters,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: const Text('Clear Filters', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 16.0),

                // Search field
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search..',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),

                // Status dropdown (with checkboxes)
                _buildStatusDropdown(),
                const SizedBox(width: 16.0),

                // Date Range Picker
                GestureDetector(
                  onTap: () => _selectDateRange(context),
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      _dateRange == null
                          ? 'Select Date Range'
                          : '${_dateRange!.start.toLocal()} - ${_dateRange!.end.toLocal()}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),

                // Sort By Dropdown
                Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _sortBy,
                    onChanged: (String? newValue) {
                      setState(() {
                        _sortBy = newValue;
                      });
                    },
                    hint: const Text('Sort By'),
                    underline: const SizedBox(),
                    items: ['Name', 'Date', 'Priority'].map((String sortBy) {
                      return DropdownMenuItem<String>(
                        value: sortBy,
                        child: Text(sortBy),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 16.0),
              ],
            ),
          ),

          // Left Arrow Indicator
          if (_showLeftArrow)
            Positioned(
              left: 0,
              child: GestureDetector(
                onTap: () => _scrollController.animateTo(
                  _scrollController.offset - 100,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0.7), Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: const Icon(Icons.chevron_left, size: 32),
                ),
              ),
            ),

          // Right Arrow Indicator
          if (_showRightArrow)
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () => _scrollController.animateTo(
                  _scrollController.offset + 100,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.white.withOpacity(0.7)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: const Icon(Icons.chevron_right, size: 32),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
