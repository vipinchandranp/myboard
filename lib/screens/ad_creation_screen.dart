import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myboard/screens/qr-code.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AdCreationScreen extends StatefulWidget {
  @override
  _AdCreationScreenState createState() => _AdCreationScreenState();
}

class _AdCreationScreenState extends State<AdCreationScreen> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Ad'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                // Media items
                // Add your media items vertically here
                TextEditorWidget(
                  controller: _textEditingController,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImageView(
                  data: 'Vipin Chandran',
                  size: 200.0,
                ),
                SizedBox(height: 8.0),
                Text(
                  'Scan QR code to advertise there',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextEditorWidget extends StatelessWidget {
  final TextEditingController controller;

  const TextEditorWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        maxLines: null,
        decoration: InputDecoration.collapsed(hintText: 'Enter your text...'),
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
