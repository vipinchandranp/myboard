import 'package:flutter/material.dart';

class AppTheme {
  static Color shimmerBaseColor = Colors.grey[300]!; // Base color for shimmer
  static Color shimmerHighlightColor = Colors.grey[100]!; // Highlight color for shimmer

  static ThemeData get lightTheme {
    return ThemeData(
      // Define color scheme for the theme
      colorScheme: ColorScheme.light(
        primary: Colors.black, // Set black as the primary color
        secondary: Colors.green, // Set green as the secondary color
      ),

      // Set scaffold background color to white
      scaffoldBackgroundColor: Colors.white,

      // AppBar theme customization
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white), // White icons for contrast
        titleTextStyle: const TextStyle(
          color: Colors.white, // White text
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
      ),

      // Text theme customization
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Black for display text
          fontFamily: 'Roboto',
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Black for headline text
          fontFamily: 'Roboto',
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          color: Colors.grey, // Dark grey for body text
          fontFamily: 'Roboto',
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          color: Colors.black, // Black text for labels
          fontFamily: 'Roboto',
        ),
      ),

      // Elevated button theme customization
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, // Black button background
          foregroundColor: Colors.green, // Cyan text for contrast
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),

      // Outlined button theme customization
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black, // Black text
          side: const BorderSide(color: Colors.green), // Cyan border
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),

      // Text button theme customization
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.green, // Cyan text
        ),
      ),

      // Input decoration theme customization
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.grey), // Grey for border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.black), // Black for focus
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.grey), // Grey for enabled
        ),
        hintStyle: const TextStyle(
          color: Colors.grey, // Grey for hint text
          fontFamily: 'Roboto',
        ),
      ),

      // Card theme customization
      cardTheme: CardTheme(
        color: Colors.white, // White card background
        shadowColor: Colors.grey.shade500, // Darker grey for card shadow
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),

      // Bottom navigation bar theme customization
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black, // Black for background
        selectedItemColor: Colors.green, // Cyan for selected item
        unselectedItemColor: Colors.grey, // Grey for unselected items
        elevation: 8,
      ),
    );
  }

  // Gradient example
  static LinearGradient get lightWhiteGradient => LinearGradient(
    colors: [Colors.black, Colors.grey.shade800],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color get secondaryColor => Colors.green; // Cyan color getter
}
