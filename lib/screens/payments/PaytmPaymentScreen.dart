import 'package:flutter/material.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

class PaytmPaymentScreen extends StatefulWidget {
  @override
  _PaytmPaymentScreenState createState() => _PaytmPaymentScreenState();
}

class _PaytmPaymentScreenState extends State<PaytmPaymentScreen> {
  String result = "Payment Result will appear here";

  void startTransaction(String orderId, String txnToken, String amount, String mid) async {
    try {
      var response = await AllInOneSdk.startTransaction(
        mid,
        orderId,
        amount,
        txnToken,
        "null", // Callback URL
        true, // Enable staging environment for testing
        false, // Restrict app payment methods
      );
      setState(() {
        result = response.toString();
      });
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Paytm Payment')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(result),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Replace with your backend-generated orderId, txnToken, amount, and mid
                startTransaction("ORDER12345", "TOKEN123", "100.00", "YOUR_MID");
              },
              child: Text("Start Paytm Transaction"),
            ),
          ],
        ),
      ),
    );
  }
}
