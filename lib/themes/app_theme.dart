import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Set primary color to black
      primaryColor: Colors.black,

      // Set hint color to a shade of grey
      hintColor: Colors.grey.shade600,

      // Set scaffold background color to a light shade of grey
      scaffoldBackgroundColor: Colors.grey.shade100,

      // AppBar theme customization
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black, // Black AppBar background
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // White icons for contrast
        titleTextStyle: TextStyle(
          color: Colors.white, // White text
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
          color: Colors.black, // Black for large text
          fontFamily: 'Roboto',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.grey.shade800, // Dark grey for body text
          fontFamily: 'Roboto',
        ),
        labelLarge: TextStyle(
          fontSize: 18,
          color: Colors.black, // Black for labels
          fontFamily: 'Roboto',
        ),
      ),

      // Elevated button theme customization
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, // Black for button background
          foregroundColor: Colors.white, // White text for contrast
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),

      // Outlined button theme customization
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black, // Black for text
          side: BorderSide(color: Colors.black), // Black for border
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),

      // Text button theme customization
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black, // Black for text
        ),
      ),

      // Input decoration theme customization
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100, // Light grey background for inputs
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              color: Colors.grey.shade400), // Light grey for border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              color: Colors.black), // Black for focused border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              color: Colors.grey.shade400), // Light grey for enabled border
        ),
        hintStyle: TextStyle(
          color: Colors.grey.shade600, // Medium grey for hint text
          fontFamily: 'Roboto',
        ),
      ),

      // Card theme customization
      cardTheme: CardTheme(
        color: Colors.grey.shade200, // Light grey for card background
        shadowColor: Colors.grey.shade500, // Grey for card shadow
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Icon theme customization
      iconTheme: IconThemeData(
        color: Colors.black, // Black for icons
      ),

      // Chip theme customization
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade300, // Light grey chip background
        disabledColor: Colors.grey.shade400,
        selectedColor: Colors.black, // Black for selected chips
        secondarySelectedColor: Colors.grey.shade500, // Dark grey for secondary selection
        padding: EdgeInsets.all(8),
        labelStyle: TextStyle(
          color: Colors.black, // Black for chip label
          fontFamily: 'Roboto',
        ),
        secondaryLabelStyle: TextStyle(
          color: Colors.grey.shade800, // Dark grey for secondary chip label
          fontFamily: 'Roboto',
        ),
        brightness: Brightness.light,
      ),

      // Slider theme customization
      sliderTheme: SliderThemeData(
        activeTrackColor: Colors.black, // Black for active track
        inactiveTrackColor: Colors.grey.shade400, // Light grey for inactive track
        thumbColor: Colors.black, // Black for thumb
        overlayColor: Colors.grey.shade300.withOpacity(0.2), // Light grey for overlay
        valueIndicatorColor: Colors.black, // Black for value indicator
      ),

      // Switch theme customization
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(Colors.black), // Black for thumb
        trackColor: MaterialStateProperty.all(Colors.grey.shade400), // Light grey for track
      ),

      // Checkbox theme customization
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(Colors.black), // Black for checkbox fill
        checkColor: MaterialStateProperty.all(Colors.white), // White for checkmark
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Radio theme customization
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all(Colors.black), // Black for radio button fill
      ),

      // Bottom navigation bar theme customization
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black, // Black for background
        selectedItemColor: Colors.white, // White for selected item
        unselectedItemColor: Colors.grey.shade500, // Light grey for unselected items
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}
