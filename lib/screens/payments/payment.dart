import 'package:flutter/material.dart';
import 'package:myboard/utils/dialog.dart';
import '../../models/payment/PaymentRequest.dart';
import '../../repository/payment_repository.dart';

class PaymentScreen extends StatelessWidget {
  final String displayId;
  final String boardId;
  final List<String> timeSlots;
  final String date;

  PaymentScreen({
    Key? key,
    required this.displayId,
    required this.boardId,
    required this.timeSlots,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentService = PaymentService(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
      ),
      body: FutureBuilder<double?>(
        future: paymentService.calculatePrice(displayId, timeSlots, date),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error);
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Price not available.'));
          }

          final price = snapshot.data!;
          return _buildPaymentContent(context, paymentService, price);
        },
      ),
    );
  }

  Widget _buildErrorState(Object? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 50, color: Colors.red),
          const SizedBox(height: 10),
          const Text('Something went wrong.'),
          if (error != null)
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentContent(BuildContext context, PaymentService paymentService, double price) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Price: \$${price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _handlePayment(context, paymentService, price),
            child: const Text('Pay Now', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel Payment', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePayment(BuildContext context, PaymentService paymentService, double price) async {
    final paymentRequest = PaymentRequest(
      displayId: displayId,
      boardId: boardId,
      amount: price,
      timeSlots: timeSlots,
      date: DateTime.parse(date),
    );

    try {
      final transactionID = await paymentService.initiatePayment(paymentRequest);

      if (transactionID != null) {
        final paymentResponse = await paymentService.processPayment(
          paymentRequest.copyWith(transactionID: transactionID),
        );

        if (paymentResponse == 'Payment processed successfully') {
          await _showSuccessDialog(context, transactionID);
        } else {
          DialogUtils.showErrorDialog(context, 'Payment failed to process.');
        }
      } else {
        DialogUtils.showErrorDialog(context, 'Failed to initiate payment.');
      }
    } catch (e) {
      DialogUtils.showErrorDialog(context, 'An error occurred: $e');
    }
  }

  Future<void> _showSuccessDialog(BuildContext context, String transactionID) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          content: Text('Your payment was successful. Transaction ID: $transactionID'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pop(context, true); // Return success
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
