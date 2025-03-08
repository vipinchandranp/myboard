import 'package:flutter/material.dart';

class AbstractFilterRequest {
  // Filter data properties
  String? searchText;
  DateTime? startDate;
  DateTime? endDate;
  List<String>? ids; // Field to filter by a list of IDs
  String? createdBy; // userId

  // Pagination properties with default values
  int page;
  int size;

  // Additional filters specific to this request
  String? status; // Filter by status
  bool? isRecent; // Filter by recent
  bool? isFavorite; // Filter by favorite

  AbstractFilterRequest({
    this.searchText,
    this.startDate,
    this.endDate,
    this.ids,
    this.createdBy,
    this.page = 0, // Default page number is 0 (first page)
    this.size = 10, // Default page size is 10
    this.status,
    this.isRecent,
    this.isFavorite,
  });

  // Factory method to create an instance from JSON
  factory AbstractFilterRequest.fromJson(Map<String, dynamic> json) {
    return AbstractFilterRequest(
      searchText: json['searchText'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      ids: (json['ids'] as List?)?.map((id) => id as String).toList(),
      createdBy: json['createdBy'],
      page: json['page'] ?? 0,
      size: json['size'] ?? 10,
      status: json['status'],
      isRecent: json['isRecent'],
      isFavorite: json['isFavorite'],
    );
  }

  // Method to convert an instance into JSON
  Map<String, dynamic> toJson() {
    return {
      'searchText': searchText,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'ids': ids,
      'createdBy': createdBy,
      'page': page,
      'size': size,
      'status': status,
      'isRecent': isRecent,
      'isFavorite': isFavorite,
    };
  }
}
