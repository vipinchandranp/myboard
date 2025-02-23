import 'package:flutter/material.dart';
import 'package:myboard/models/display/bdisplay.dart';
import 'package:myboard/screens/payments/payment.dart';
import 'package:myboard/screens/display/selected_board.dart';
import 'package:myboard/screens/display/selected_time_slot_section.dart';
import 'package:myboard/screens/display/timeslots.dart';
import '../../models/board/board.dart';
import '../../utils/view_mode.dart';
import '../../widgets/round_button.dart';
import '../board/view_boards.dart';

class StepperScreen extends StatefulWidget {
  final BDisplay display;

  const StepperScreen({Key? key, required this.display}) : super(key: key);

  @override
  _StepperScreenState createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  DateTime? _selectedDate;
  List<String>? _selectedTimeSlots;
  Board? _selectedBoard;
  bool _isPaymentSuccessful = false;
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Display: ${widget.display.displayName}',
          style: const TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _currentStep == 2 ? null : _onStepContinue,
          onStepCancel: _currentStep == 0 ? null : _onStepCancel,
          controlsBuilder: (context, details) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                OutlinedButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Back'),
                ),
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: const Text('Next'),
              ),
            ],
          ),
          steps: [
            Step(
              title: const Text('Select Time Slot'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectedTimeSlotSectionWidget(
                    selectedDate: _selectedDate,
                    selectedTimeSlots: _selectedTimeSlots,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _showBookingDialog,
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Select Time Slots'),
                    ),
                  ),
                ],
              ),
              isActive: _currentStep == 0,
            ),
            Step(
              title: const Text('Select Board'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: RoundedButton(
                      icon: Icons.dashboard,
                      label: 'Select Board',
                      onPressed: _selectBoard,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_selectedBoard != null)
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SelectedBoardWidget(selectedBoard: _selectedBoard),
                      ),
                    ),
                ],
              ),
              isActive: _currentStep == 1,
            ),
            Step(
              title: const Text('Make Payment'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _navigateToPayment,
                      icon: const Icon(Icons.payment),
                      label: const Text('Proceed to Payment'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isPaymentSuccessful)
                    const Text(
                      'Payment Successful!',
                      style: TextStyle(color: Colors.green, fontSize: 16),
                    ),
                ],
              ),
              isActive: _currentStep == 2,
            ),
          ],
        ),
      ),
    );
  }

  void _onStepContinue() {
    setState(() {
      if (_currentStep < 2) _currentStep++;
    });
  }

  void _onStepCancel() {
    setState(() {
      if (_currentStep > 0) _currentStep--;
    });
  }

  void _showBookingDialog() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeSlotWidget(displayId: widget.display.displayId),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedDate = result['selectedDate'];
        _selectedTimeSlots = result['selectedSlots'];
      });
    }
  }

  void _selectBoard() async {
    final selectedBoard = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewBoardsWidget(
          viewMode: ViewMode.timeslotBoardSelection,
        ),
      ),
    );

    if (selectedBoard != null) {
      setState(() {
        _selectedBoard = selectedBoard;
      });
    }
  }

  void _navigateToPayment() async {
    if (_selectedBoard == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a board first.')),
      );
      return;
    }

    final paymentSuccess = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          displayId: widget.display.displayId,
          boardId: _selectedBoard!.boardId,
          timeSlots: _selectedTimeSlots ?? [],
          date: _selectedDate?.toIso8601String() ?? '',
        ),
      ),
    );

    setState(() {
      _isPaymentSuccessful = paymentSuccess == true;
    });

    if (_isPaymentSuccessful) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful!')),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment failed. Please try again.')),
      );
    }
  }
}
