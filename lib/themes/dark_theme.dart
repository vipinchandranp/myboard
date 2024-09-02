import 'package:flutter/material.dart';
import 'custom_colors.dart';

ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    primaryColor: CustomColors.darkPrimary,
    hintColor: CustomColors.darkAccent,  // Changed accentColor to hintColor for consistency
    scaffoldBackgroundColor: Colors.black,
    // Customize other theme properties here
    textTheme: _buildTextTheme(base.textTheme, Colors.white),
  );
}

TextTheme _buildTextTheme(TextTheme base, Color color) {
  return base.copyWith(
    displayLarge: base.displayLarge!.copyWith(color: color),
    bodyLarge: base.bodyLarge!.copyWith(color: color),
    // Add more text styles as needed using the updated properties
  );
}
