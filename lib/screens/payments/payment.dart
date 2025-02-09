import 'package:flutter/material.dart';
import 'package:myboard/utils/dialog.dart';

import '../../models/payment/PaymentRequest.dart';
import '../../repository/payment_repository.dart';

class PaymentScreen extends StatelessWidget {
  final String displayId; // Display ID
  final String boardId; // Board ID
  final List<String> timeSlots; // List of time slots
  final String date; // Date for the booking

  // Constructor with required parameters for displayId, boardId, timeSlots, and date
  PaymentScreen({
    Key? key,
    required this.displayId,
    required this.boardId,
    required this.timeSlots,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initializing the PaymentService
    final paymentService = PaymentService(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: FutureBuilder<double?>(
        future: paymentService.calculatePrice(displayId, timeSlots, date), // Fetching the calculated price
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Price not available'));
          }

          final price = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Price: \$${price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Create a PaymentRequest with displayId and boardId
                    final paymentRequest = PaymentRequest(
                      displayId: displayId,
                      boardId: boardId, // Include boardId in the request
                      amount: price,
                      timeSlots: timeSlots,
                      date: DateTime.parse(date),
                    );

                    // Initiate payment process
                    try {
                      final txId = await paymentService.initiatePayment(paymentRequest);
                      if (txId != null && txId.isNotEmpty) {
                        // Create a new PaymentRequest instance with the transactionId
                        final updatedPaymentRequest = PaymentRequest(
                          displayId: paymentRequest.displayId,
                          boardId: paymentRequest.boardId,
                          amount: paymentRequest.amount,
                          timeSlots: paymentRequest.timeSlots,
                          date: paymentRequest.date,
                          transactionId: txId, // Set the transactionId
                        );

                        // If payment initiation was successful, attempt to process payment
                        final processResponse = await paymentService.processPayment(updatedPaymentRequest);
                        if (processResponse == 'Payment processed successfully') {
                          // Payment processed successfully
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Payment Successful'),
                                content: Text('Your payment was successful. Transaction ID: $txId'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                      Navigator.pop(context, true); // Go back to the parent screen
                                    },
                                    child: const Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // Payment processing failed
                          DialogUtils.showErrorDialog(context, 'Payment failed to process');
                        }
                      } else {
                        // Payment initiation failed
                        DialogUtils.showErrorDialog(context, 'Payment initiation failed');
                      }
                    } catch (e) {
                      // Handle any errors during payment process
                      DialogUtils.showErrorDialog(context, 'Error: $e');
                    }
                  },
                  child: const Text('Pay Now'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Simulate failed payment
                    Navigator.pop(context, false); // Simulate failure
                  },
                  child: const Text('Cancel Payment'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
