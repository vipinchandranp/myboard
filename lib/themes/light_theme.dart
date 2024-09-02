import 'package:flutter/material.dart';
import 'custom_colors.dart';

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: CustomColors.lightPrimary,
    hintColor: CustomColors.lightAccent,
    scaffoldBackgroundColor: Colors.white,
    // Customize other theme properties here
    textTheme: _buildTextTheme(base.textTheme, Colors.black),
  );
}

TextTheme _buildTextTheme(TextTheme base, Color color) {
  return base.copyWith(
    displayLarge: base.displayLarge!.copyWith(color: color),
    bodyLarge: base.bodyLarge!.copyWith(color: color),
    // Add more text styles if needed using the updated properties
  );
}
