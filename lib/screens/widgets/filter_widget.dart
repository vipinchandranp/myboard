import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class FilterWidget extends StatefulWidget {
  final List<String> suggestions; // Suggestions for autocomplete
  final Function(String) onSearchChanged; // Callback for search input
  final DateTimeRange? dateRange; // Selected date range
  final Function(DateTimeRange?) onDateRangeChanged; // Callback for date range selection
  final String? selectedStatus; // Selected status
  final Function(String?) onStatusChanged; // Callback for status selection
  final bool isRecent; // Is Recent filter active
  final Function(bool) onRecentToggle; // Callback for recent toggle
  final bool isFavorite; // Is Favorite filter active
  final Function(bool) onFavoriteToggle; // Callback for favorite toggle

  FilterWidget({
    required this.suggestions,
    required this.onSearchChanged,
    required this.dateRange,
    required this.onDateRangeChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.isRecent,
    required this.onRecentToggle,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Autocomplete Search Box
            TypeAheadField<String>(
              suggestionsCallback: (pattern) {
                return widget.suggestions.where(
                        (s) => s.toLowerCase().contains(pattern.toLowerCase()));
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) {
                _searchController.text = suggestion;
                widget.onSearchChanged(suggestion); // Trigger callback
              },
              textFieldConfiguration: TextFieldConfiguration(
                controller: _searchController,
                onChanged: (value) {
                  widget.onSearchChanged(value); // Trigger callback as user types
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Date Range Picker
            Row(
              children: [
                Text(
                  'Date Range: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Text(
                  widget.dateRange != null
                      ? '${widget.dateRange!.start.toLocal()} - ${widget.dateRange!.end.toLocal()}'
                      : 'Select Date Range',
                  style: TextStyle(color: Colors.grey),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTimeRange? picked = await showDateRangePicker(
                      context: context,
                      initialDateRange: widget.dateRange,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    widget.onDateRangeChanged(picked); // Trigger callback
                  },
                ),
              ],
            ),
            SizedBox(height: 16),

            // Status Dropdown
            DropdownButton<String>(
              isExpanded: true,
              value: widget.selectedStatus,
              hint: Text('Select Status'),
              items: ['Active', 'Inactive', 'Pending'].map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (status) {
                widget.onStatusChanged(status); // Trigger callback
              },
            ),
            SizedBox(height: 16),

            // Recent Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Show Recent'),
                Switch(
                  value: widget.isRecent,
                  onChanged: (value) {
                    widget.onRecentToggle(value); // Trigger callback
                  },
                ),
              ],
            ),
            SizedBox(height: 16),

            // Favorite Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Show Favorites'),
                Switch(
                  value: widget.isFavorite,
                  onChanged: (value) {
                    widget.onFavoriteToggle(value); // Trigger callback
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
