import 'package:flutter/material.dart';

enum StatusType {
  UNAVAILABLE,
  AVAILABLE,
  WAITING_FOR_APPROVAL,
  APPROVED,
  REJECTED,
  WAITING_FOR_VALIDATION,
  VALIDATED,
  WAITING_FOR_DISPLAY,
  DISPLAYED,
  TRANSACTION_COMPLETE,
  PAYMENT_COMPLETED,
  PAYMENT_FAILED,
  PAYMENT_IN_PROGRESS,
  PAYMENT_INITIATED,
}

// Extension to add values, colors, short descriptions, and mapping from String to StatusType
extension StatusTypeExtension on StatusType {
  /// Provides the display value of the status
  String get value {
    switch (this) {
      case StatusType.UNAVAILABLE:
        return 'Unavailable';
      case StatusType.AVAILABLE:
        return 'Available';
      case StatusType.WAITING_FOR_APPROVAL:
        return 'Waiting for Approval';
      case StatusType.APPROVED:
        return 'Approved';
      case StatusType.REJECTED:
        return 'Rejected';
      case StatusType.WAITING_FOR_VALIDATION:
        return 'Waiting for Validation';
      case StatusType.VALIDATED:
        return 'Validated';
      case StatusType.WAITING_FOR_DISPLAY:
        return 'Waiting for Display';
      case StatusType.DISPLAYED:
        return 'Displayed';
      case StatusType.TRANSACTION_COMPLETE:
        return 'Transaction Complete';
      case StatusType.PAYMENT_COMPLETED:
        return 'Payment Completed';
      case StatusType.PAYMENT_FAILED:
        return 'Payment Failed';
      case StatusType.PAYMENT_IN_PROGRESS:
        return 'Payment in Progress';
      case StatusType.PAYMENT_INITIATED:
        return 'Payment Initiated';
      default:
        return '';
    }
  }

  /// Provides a short description of the status
  String get shortDescription {
    switch (this) {
      case StatusType.UNAVAILABLE:
        return 'Not available for use.';
      case StatusType.AVAILABLE:
        return 'Ready to use.';
      case StatusType.WAITING_FOR_APPROVAL:
        return 'Awaiting approval process.';
      case StatusType.APPROVED:
        return 'Approval granted.';
      case StatusType.REJECTED:
        return 'Approval denied.';
      case StatusType.WAITING_FOR_VALIDATION:
        return 'Pending validation.';
      case StatusType.VALIDATED:
        return 'Successfully validated.';
      case StatusType.WAITING_FOR_DISPLAY:
        return 'Pending display setup.';
      case StatusType.DISPLAYED:
        return 'Currently displayed.';
      case StatusType.TRANSACTION_COMPLETE:
        return 'Transaction finished.';
      case StatusType.PAYMENT_COMPLETED:
        return 'Payment successfully made.';
      case StatusType.PAYMENT_FAILED:
        return 'Payment did not succeed.';
      case StatusType.PAYMENT_IN_PROGRESS:
        return 'Payment being processed.';
      case StatusType.PAYMENT_INITIATED:
        return 'Payment started.';
      default:
        return '';
    }
  }

  /// Returns a color representation of the status
  Color get color {
    switch (this) {
      case StatusType.UNAVAILABLE:
        return Colors.red;
      case StatusType.AVAILABLE:
        return Colors.green;
      case StatusType.WAITING_FOR_APPROVAL:
        return Colors.orange;
      case StatusType.APPROVED:
        return Colors.lightGreen;
      case StatusType.REJECTED:
        return Colors.deepOrange;
      case StatusType.WAITING_FOR_VALIDATION:
        return Colors.yellow;
      case StatusType.VALIDATED:
        return Colors.lime;
      case StatusType.WAITING_FOR_DISPLAY:
        return Colors.blueAccent;
      case StatusType.DISPLAYED:
        return Colors.blue;
      case StatusType.TRANSACTION_COMPLETE:
        return Colors.indigo;
      case StatusType.PAYMENT_COMPLETED:
        return Colors.greenAccent;
      case StatusType.PAYMENT_FAILED:
        return Colors.redAccent;
      case StatusType.PAYMENT_IN_PROGRESS:
        return Colors.amber;
      case StatusType.PAYMENT_INITIATED:
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  /// Converts a string to a StatusType enum
  static StatusType fromString(String value) {
    switch (value) {
      case 'UNAVAILABLE':
        return StatusType.UNAVAILABLE;
      case 'AVAILABLE':
        return StatusType.AVAILABLE;
      case 'WAITING_FOR_APPROVAL':
        return StatusType.WAITING_FOR_APPROVAL;
      case 'APPROVED':
        return StatusType.APPROVED;
      case 'REJECTED':
        return StatusType.REJECTED;
      case 'WAITING_FOR_VALIDATION':
        return StatusType.WAITING_FOR_VALIDATION;
      case 'VALIDATED':
        return StatusType.VALIDATED;
      case 'WAITING_FOR_DISPLAY':
        return StatusType.WAITING_FOR_DISPLAY;
      case 'DISPLAYED':
        return StatusType.DISPLAYED;
      case 'TRANSACTION_COMPLETE':
        return StatusType.TRANSACTION_COMPLETE;
      case 'PAYMENT_COMPLETED':
        return StatusType.PAYMENT_COMPLETED;
      case 'PAYMENT_FAILED':
        return StatusType.PAYMENT_FAILED;
      case 'PAYMENT_IN_PROGRESS':
        return StatusType.PAYMENT_IN_PROGRESS;
      case 'PAYMENT_INITIATED':
        return StatusType.PAYMENT_INITIATED;
      default:
        throw ArgumentError('Invalid status type: $value');
    }
  }
}
