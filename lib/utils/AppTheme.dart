import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    // Define your light theme properties here
    primaryColor: Colors.teal,
    // Add more theme properties as needed
    // Example: textTheme, appBarTheme, buttonTheme, etc.
  );

  static ThemeData darkTheme = ThemeData(
    // Define your dark theme properties here
    primaryColor: Colors.black,
    // Add more theme properties as needed
    // Example: textTheme, appBarTheme, buttonTheme, etc.
  );
  // Define your theme colors
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.yellow;
  static const Color accentColor = Colors.red;

  // Define text styles
  static const TextStyle headlineTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  // Define button styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );
}
