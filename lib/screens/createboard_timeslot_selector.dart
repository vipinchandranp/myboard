import 'package:flutter/material.dart';

class TimeSlotSelector extends StatefulWidget {
  final Function(List<TimeOfDay>) onTimeSelected;

  TimeSlotSelector({required this.onTimeSelected});

  @override
  _TimeSlotSelectorState createState() => _TimeSlotSelectorState();
}

class _TimeSlotSelectorState extends State<TimeSlotSelector> {
  List<TimeOfDay> selectedTimes = [
    TimeOfDay(hour: 10, minute: 0),
  ]; // Adjust initial timeSlots
  List<TimeOfDay> timeSlots = [];

  @override
  void initState() {
    super.initState();
    generateTimeSlots();
  }

  void generateTimeSlots() {
    final TimeOfDay startTime = TimeOfDay(hour: 10, minute: 0);
    final TimeOfDay endTime = TimeOfDay(hour: 22, minute: 0);
    final Duration step = Duration(hours: 1);

    timeSlots = getTimes(startTime, endTime, step).toList();
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
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedTimes.contains(timeSlots[index])) {
                    selectedTimes.remove(timeSlots[index]);
                  } else {
                    selectedTimes.add(timeSlots[index]);
                  }
                });
                widget.onTimeSelected(selectedTimes);
              },
              child: Container(
                color: selectedTimes.contains(timeSlots[index])
                    ? Colors.blue
                    : Colors.grey,
                child: Center(
                  child: Text(
                    '${TimeOfDayFormatter.formatTimeOfDay(timeSlots[index])}',
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
    return selectedTimes
        .map((time) => TimeOfDayFormatter.formatTimeOfDay(time))
        .join(', ');
  }

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;
    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }
}

class TimeOfDayFormatter {
  static String formatTimeOfDay(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }
}
