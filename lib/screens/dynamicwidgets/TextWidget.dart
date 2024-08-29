import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final Map<String, dynamic> config;

  const TextWidget({Key? key, required this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      config['text'] ?? '',
      style: TextStyle(
        fontSize: config['fontSize'] ?? 16.0,
        fontWeight: config['fontWeight'] ?? FontWeight.normal,
      ),
    );
  }
}