import 'package:flutter/material.dart';

import '../../utils/utility.dart';

class SelectedTimeSlotSectionWidget extends StatelessWidget {
  final List<String>? selectedTimeSlots;
  final DateTime? selectedDate; // New DateTime parameter

  const SelectedTimeSlotSectionWidget({
    Key? key,
    this.selectedTimeSlots,
    this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (selectedDate != null) {
      children.add(Text(
        'Selected Date: ${Utility.formatDate(selectedDate!)}', // Display selected date
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ));
    }

    if (selectedTimeSlots != null && selectedTimeSlots!.isNotEmpty) {
      children.add(const SizedBox(height: 12));
      children.add(const Text(
        'Selected Time Slots:',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ));
      children.addAll(selectedTimeSlots!.map((slot) => Text(slot)).toList());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.isNotEmpty ? children : [const SizedBox.shrink()],
    );
  }
}
