import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myboard/screens/dynamicwidgets/RootDynamicWidget.dart';

class ContainerWidget extends StatelessWidget {
  final Map<String, dynamic> config;

  const ContainerWidget({Key? key, required this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: config['width'] ?? double.infinity,
      height: config['height'] ?? double.infinity,
      color: config['color'] != null ? Color(int.parse(config['color'])) : null,
      child: DynamicWidget(jsonConfig: json.encode(config['child'] ?? {})),
    );
  }
}