class FilterData {
  final String? searchText;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? sortBy;
  final List<String>? ids; // Renamed field to store a list of IDs

  FilterData({
    this.searchText,
    this.startDate,
    this.endDate,
    this.sortBy,
    this.ids,
  });

  // To create a copy with modified properties
  FilterData copyWith({
    String? searchText,
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy,
    List<String>? ids, // Include ids in the copyWith method
  }) {
    return FilterData(
      searchText: searchText ?? this.searchText,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortBy: sortBy ?? this.sortBy,
      ids: ids ?? this.ids,
    );
  }

  // Converts filter data to query parameters for API requests
  Map<String, String> toQueryParams() {
    final Map<String, String> queryParams = {};

    // Add each filter to the query parameters if it is not null
    if (searchText != null && searchText!.isNotEmpty) {
      queryParams['searchText'] = searchText!;
    }
    if (startDate != null) {
      queryParams['startDate'] = startDate!.toIso8601String();
    }
    if (endDate != null) {
      queryParams['endDate'] = endDate!.toIso8601String();
    }
    if (sortBy != null && sortBy!.isNotEmpty) {
      queryParams['sortBy'] = sortBy!;
    }
    if (ids != null && ids!.isNotEmpty) {
      // Convert list of IDs into a single, comma-separated string
      queryParams['ids'] = ids!.join(',');
    }

    return queryParams;
  }
}
