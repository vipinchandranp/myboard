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
}
