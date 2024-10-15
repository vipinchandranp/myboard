import 'package:flutter/material.dart';

class BoardFilter {
  final int page;
  final int size;
  final List<String>? boardIds;
  final String? searchText;
  final DateTimeRange? dateRange;
  final String? status;
  final bool? isRecent;
  final bool? isFavorite;

  BoardFilter({
    required this.page,
    required this.size,
    this.boardIds,
    this.searchText,
    this.dateRange,
    this.status,
    this.isRecent,
    this.isFavorite,
  });

  Map<String, dynamic> toQueryParams() {
    return {
      'page': page.toString(),
      'size': size.toString(),
      if (searchText != null && searchText!.isNotEmpty) 'search': searchText,
      if (dateRange != null) 'startDate': dateRange!.start.toIso8601String(),
      if (dateRange != null) 'endDate': dateRange!.end.toIso8601String(),
      if (status != null) 'status': status,
      if (isRecent != null) 'recent': isRecent.toString(),
      if (isFavorite != null) 'favorite': isFavorite.toString(),
      if (boardIds != null && boardIds!.isNotEmpty)
        'boardIds': boardIds!.join(','), // Join boardIds into a comma-separated string
    };
  }
}
