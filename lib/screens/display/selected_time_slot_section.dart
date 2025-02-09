import 'package:flutter/material.dart';
import '../../utils/utility.dart';

class SelectedTimeSlotSectionWidget extends StatelessWidget {
  final List<String>? selectedTimeSlots;
  final DateTime? selectedDate;

  const SelectedTimeSlotSectionWidget({
    Key? key,
    this.selectedTimeSlots,
    this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the app's theme
    final primaryColor = theme.colorScheme.primary; // Use primary color dynamically

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedDate != null)
              Text(
                'Selected Date: ${Utility.formatDate(selectedDate!)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
            if (selectedDate != null && selectedTimeSlots != null && selectedTimeSlots!.isNotEmpty)
              const SizedBox(height: 12),
            if (selectedTimeSlots != null && selectedTimeSlots!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Time Slots:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedTimeSlots!
                        .map(
                          (slot) => Chip(
                        label: Text(
                          slot,
                          style: TextStyle(color: theme.colorScheme.onPrimary),
                        ),
                        backgroundColor: primaryColor,
                      ),
                    )
                        .toList(),
                  ),
                ],
              ),
            if (selectedDate == null && (selectedTimeSlots == null || selectedTimeSlots!.isEmpty))
              Center(
                child: Text(
                  'No time slots selected.',
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
