import 'package:flutter/material.dart';

class DialogUtils {
  // Prevent instantiation
  DialogUtils._();

  // Helper function to show error dialogs
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
