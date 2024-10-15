import 'package:flutter/material.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onBook;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ActionButtonsWidget({
    Key? key,
    required this.onBook,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onBook,
          child: const Text('Associate Board'),
        ),
        ElevatedButton(
          onPressed: onEdit,
          child: const Text('Edit'),
        ),
        ElevatedButton(
          onPressed: onDelete,
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
