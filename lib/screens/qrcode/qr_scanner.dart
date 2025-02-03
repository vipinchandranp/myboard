import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myboard/repository/display_repository.dart'; // Import the DisplayService
import 'package:myboard/models/display/bdisplay.dart'; // Import the BDisplay model
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:myboard/screens/display/stepper_screen.dart'; // Import StepperScreen

class QRScannerWidget extends StatefulWidget {
  @override
  _QRScannerWidgetState createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  QRViewController? controller;
  Barcode? result;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.blueGrey,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 250,
            ),
          ),
          if (result != null)
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Text(
                  'Result: ${result!.code}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (scanData.format == BarcodeFormat.qrcode && scanData.code!.isNotEmpty) {
        controller.pauseCamera(); // Pause camera on successful scan
        setState(() {
          result = scanData; // Store the result
        });
        _fetchDisplay(scanData.code!); // Fetch the BDisplay by QR code
      }
    });
  }

  // Fetch display details by the QR code
  void _fetchDisplay(String displayId) async {
    try {
      BDisplay? display = await DisplayService(context).getDisplayById(displayId);
      if (display != null) {
        // Navigate to the StepperScreen with the fetched display
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StepperScreen(display: display),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Display not found for the scanned QR code.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching display: $e')),
      );
    }
  }
}
