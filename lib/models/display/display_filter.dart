import 'package:flutter/material.dart';

class DisplayFilter {
  final String? searchText;
  final DateTimeRange? dateRange;
  final String? status;
  final bool isRecent;
  final bool isFavorite;
  final int page; // New property for page number
  final int size; // New property for page size

  DisplayFilter({
    this.searchText,
    this.dateRange,
    this.status,
    this.isRecent = false,
    this.isFavorite = false,
    this.page = 0, // Default page number
    this.size = 20, // Default page size
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      if (searchText != null && searchText!.isNotEmpty) 'searchText': searchText,
      if (dateRange != null) 'startDate': dateRange!.start.toIso8601String(),
      if (dateRange != null) 'endDate': dateRange!.end.toIso8601String(),
      if (status != null) 'status': status,
      'isRecent': isRecent.toString(),
      'isFavorite': isFavorite.toString(),
      'page': page.toString(), // Add page number to query parameters
      'size': size.toString(), // Add page size to query parameters
    };
  }
}
