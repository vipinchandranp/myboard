import 'package:flutter/material.dart';
import '../../../types/status_type.dart';

class StatusButton extends StatelessWidget {
  final String status;

  const StatusButton({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convert the status string to StatusType enum
    StatusType statusType;
    try {
      statusType = StatusTypeExtension.fromString(status);
    } catch (e) {
      // If the status string is invalid, fall back to UNAVAILABLE
      statusType = StatusType.UNAVAILABLE;
    }

    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: statusType.color.withOpacity(0.2),
        border: Border.all(color: statusType.color),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        statusType.shortDescription,
        style: TextStyle(
          color: statusType.color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
