import 'package:flutter/material.dart';

class TimeSlotSelector extends StatefulWidget {
  final List<String> availableTimeSlots;
  final List<String> bookedTimeslots;
  final List<String> selectedTimeSlots;
  final Function(List<String>) onTimeSelected;

  TimeSlotSelector({
    required this.availableTimeSlots,
    required this.bookedTimeslots,
    required this.selectedTimeSlots,
    required this.onTimeSelected,
  });

  @override
  _TimeSlotSelectorState createState() => _TimeSlotSelectorState();
}

class _TimeSlotSelectorState extends State<TimeSlotSelector> {
  late List<String> timeSlots;

  @override
  void initState() {
    super.initState();
    generateTimeSlots();
  }

  void generateTimeSlots() {
    // You can customize this logic based on your requirements
    timeSlots = List.from(widget.availableTimeSlots);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Selected Times: ${formatSelectedTimes()}',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 16),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 2.0, // Adjust the aspect ratio as needed
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: timeSlots.length,
          itemBuilder: (context, index) {
            final timeSlot = timeSlots[index];
            final isAvailable = widget.availableTimeSlots.contains(timeSlot);
            final isSelected = widget.selectedTimeSlots.contains(timeSlot);
            final isUnavailable = widget.bookedTimeslots
                .any((booking) => booking.startsWith(timeSlot.split('-')[0]));

            Color cellColor;

            if (isUnavailable) {
              cellColor = Colors.red; // Unavailable time slot color
            } else if (isSelected) {
              cellColor = Colors.blue; // Selected time slot color
            } else if (isAvailable) {
              cellColor = Colors.green; // Available time slot color
            } else {
              cellColor = Colors.grey; // Default color
            }

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isAvailable && !isUnavailable) {
                    if (isSelected) {
                      widget.selectedTimeSlots.remove(timeSlot);
                    } else {
                      widget.selectedTimeSlots.add(timeSlot);
                    }
                  }
                });
                widget.onTimeSelected(widget.selectedTimeSlots);
              },
              child: Container(
                color: cellColor,
                child: Center(
                  child: Text(
                    '$timeSlot',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String formatSelectedTimes() {
    return widget.selectedTimeSlots.join(', ');
  }
}
