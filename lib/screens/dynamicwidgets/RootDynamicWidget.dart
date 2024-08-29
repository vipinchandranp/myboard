import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myboard/screens/dynamicwidgets/ContainerWidget.dart';
import 'package:myboard/screens/dynamicwidgets/TextWidget.dart';

class DynamicWidget extends StatelessWidget {
  final String jsonConfig;

  const DynamicWidget({Key? key, required this.jsonConfig}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse JSON configuration
    Map<String, dynamic> config = json.decode(jsonConfig);

    // Build widget based on widget type
    switch (config['widgetType']) {
      case 'Text':
        return TextWidget(config: config);
      case 'Container':
        return ContainerWidget(config: config);
    // Add more cases for other widget types as needed
      default:
        throw Exception('Unsupported widget type: ${config['widgetType']}');
    }
  }
}