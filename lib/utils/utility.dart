import 'package:flutter/material.dart';

class Utility {
  static Color getStatusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return Colors.green;
      case 'WAITING_FOR_APPROVAL':
        return Colors.orange;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static String formatDate(DateTime dateTime) {
    return dateTime.toLocal().toString().split(' ')[0];
  }
}
