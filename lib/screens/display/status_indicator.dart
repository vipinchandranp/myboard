import 'package:flutter/material.dart';

class StatusIndicatorWidget extends StatelessWidget {
  final String status;

  const StatusIndicatorWidget({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status) {
      case 'active':
        color = Colors.green;
        break;
      case 'inactive':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 12),
        const SizedBox(width: 6),
        Text(
          status,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
