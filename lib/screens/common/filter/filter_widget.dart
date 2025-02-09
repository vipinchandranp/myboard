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
  List<String> _statusFilters = [];
  final ScrollController _scrollController = ScrollController();

  Map<String, dynamic> getFilterData() {
    return {
      'searchText': _searchController.text,
      'startDate': _dateRange?.start,
      'endDate': _dateRange?.end,
      'sortBy': _sortBy,
      'statusFilters': _statusFilters,
    };
  }

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

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _dateRange = null;
      _sortBy = null;
      _statusFilters.clear();
    });
    widget.onApplyFilter(getFilterData());
  }

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
        return ['Favourites', 'Approved', 'Rejected', 'Waiting For Approval']
            .map((status) {
          return CheckedPopupMenuItem<String>(
            value: status,
            checked: _statusFilters.contains(status),
            child: Text(status, style: const TextStyle(fontSize: 12)),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: const Text('Status', style: TextStyle(fontSize: 12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => widget.onApplyFilter(getFilterData()),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              ),
              child: const Text('Apply Filter', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(width: 8.0),
            ElevatedButton(
              onPressed: _clearFilters,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              ),
              child: const Text('Clear Filters', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(width: 20.0),
            SizedBox(
              width: 150,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                ),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 10.0),
            _buildStatusDropdown(),
            const SizedBox(width: 10.0),
            GestureDetector(
              onTap: () => _selectDateRange(context),
              child: Container(
                width: 160,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  _dateRange == null
                      ? 'Date Range'
                      : '${_dateRange!.start.toLocal()} - ${_dateRange!.end.toLocal()}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Container(
              width: 120,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: _sortBy,
                onChanged: (String? newValue) {
                  setState(() {
                    _sortBy = newValue;
                  });
                },
                hint: const Text('Sort By', style: TextStyle(fontSize: 12)),
                underline: const SizedBox(),
                items: ['Name', 'Date', 'Priority'].map((String sortBy) {
                  return DropdownMenuItem<String>(
                    value: sortBy,
                    child: Text(sortBy, style: const TextStyle(fontSize: 12)),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
