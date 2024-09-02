import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Set primary color to a shade of blue
      primaryColor: Colors.blue.shade700,

      // Set hint color to a shade of yellow
      hintColor: Colors.yellow.shade600,

      // Set scaffold background color to a light shade of blue
      scaffoldBackgroundColor: Colors.blue.shade50,

      // AppBar theme customization
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue.shade800, // Darker blue
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.yellow.shade100), // Light yellow for icons
        titleTextStyle: TextStyle(
          color: Colors.yellow.shade100, // Light yellow for text
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto', // Change to your desired font family
        ),
      ),

      // Text theme customization
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade900, // Darker blue for large text
          fontFamily: 'Roboto', // Change to your desired font family
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.blue.shade700, // Medium blue for body text
          fontFamily: 'Roboto', // Change to your desired font family
        ),
        labelLarge: TextStyle(
          fontSize: 18,
          color: Colors.yellow.shade700, // Darker yellow for labels
          fontFamily: 'Roboto', // Change to your desired font family
        ),
      ),

      // Elevated button theme customization
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600, // Medium blue for button background
          foregroundColor: Colors.yellow.shade100, // Light yellow for button text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),

      // Outlined button theme customization
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blue.shade700, // Darker blue for text
          side: BorderSide(color: Colors.blue.shade700), // Darker blue for border
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),

      // Text button theme customization
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue.shade800, // Darker blue for text
        ),
      ),

      // Input decoration theme customization
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.yellow.shade50, // Light yellow for input background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue.shade200), // Light blue for border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue.shade600), // Medium blue when focused
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue.shade200), // Light blue when enabled
        ),
        hintStyle: TextStyle(
          color: Colors.blue.shade300, // Lighter blue for hint text
          fontFamily: 'Roboto', // Change to your desired font family
        ),
      ),

      // Card theme customization
      cardTheme: CardTheme(
        color: Colors.yellow.shade100, // Light yellow for card background
        shadowColor: Colors.blue.shade300, // Light blue for card shadow
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Icon theme customization
      iconTheme: IconThemeData(
        color: Colors.blue.shade600, // Medium blue for icons
      ),

      // Chip theme customization
      chipTheme: ChipThemeData(
        backgroundColor: Colors.blue.shade100, // Light blue for chip background
        disabledColor: Colors.grey.shade400,
        selectedColor: Colors.blue.shade400, // Medium blue when selected
        secondarySelectedColor: Colors.blue.shade200, // Light blue when secondary selected
        padding: EdgeInsets.all(8),
        labelStyle: TextStyle(
          color: Colors.blue.shade900, // Darker blue for label text
          fontFamily: 'Roboto', // Change to your desired font family
        ),
        secondaryLabelStyle: TextStyle(
          color: Colors.yellow.shade900, // Dark yellow for secondary label text
          fontFamily: 'Roboto', // Change to your desired font family
        ),
        brightness: Brightness.light,
      ),

      // Slider theme customization
      sliderTheme: SliderThemeData(
        activeTrackColor: Colors.blue.shade700, // Medium blue for active track
        inactiveTrackColor: Colors.blue.shade300, // Lighter blue for inactive track
        thumbColor: Colors.yellow.shade600, // Medium yellow for thumb
        overlayColor: Colors.blue.shade100.withOpacity(0.2), // Light blue for overlay
        valueIndicatorColor: Colors.blue.shade600, // Medium blue for value indicator
      ),

      // Switch theme customization
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(Colors.yellow.shade600), // Medium yellow for thumb
        trackColor: MaterialStateProperty.all(Colors.blue.shade200.withOpacity(0.5)), // Light blue for track
      ),

      // Checkbox theme customization
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(Colors.blue.shade600), // Medium blue for checkbox fill
        checkColor: MaterialStateProperty.all(Colors.yellow.shade100), // Light yellow for check color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Radio theme customization
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all(Colors.blue.shade600), // Medium blue for radio fill
      ),

      // Bottom navigation bar theme customization
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.blue.shade800, // Darker blue for background
        selectedItemColor: Colors.yellow.shade100, // Light yellow for selected item
        unselectedItemColor: Colors.yellow.shade300, // Lighter yellow for unselected items
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto', // Change to your desired font family
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontFamily: 'Roboto', // Change to your desired font family
        ),
      ),
    );
  }
}
