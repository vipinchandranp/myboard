import 'package:flutter/material.dart';

class AppTheme {
  static Color shimmerBaseColor = Colors.grey[300]!; // Base color for shimmer
  static Color shimmerHighlightColor =
  Colors.grey[100]!; // Highlight color for shimmer

  static ThemeData get lightTheme {
    return ThemeData(
      // Define color scheme for the theme
      colorScheme: ColorScheme.light(
        primary: Colors.teal, // Set teal as the primary color
        secondary: Colors.grey.shade200, // Light grey for secondary color
      ),

      // Set scaffold background color to white
      scaffoldBackgroundColor: Colors.white,
      // White background

      // AppBar theme customization
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        // White AppBar background
        elevation: 4,
        iconTheme: IconThemeData(color: Colors.teal), // Teal icons for contrast
        titleTextStyle: TextStyle(
          color: Colors.black, // Black text
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
      ),

      // Text theme customization
      textTheme: TextTheme(
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
          color: Colors.grey.shade700, // Dark grey for body text
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
          backgroundColor: Colors.teal, // Teal button background
          foregroundColor: Colors.white, // White text for contrast
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),

      // Outlined button theme customization
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.teal, // Teal for text
          side: BorderSide(color: Colors.grey.shade300), // Light grey border
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),

      // Text button theme customization
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.teal, // Teal text
        ),
      ),

      // Input decoration theme customization
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        // Light grey background for inputs
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide:
          BorderSide(color: Colors.grey.shade300), // Light grey for border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide:
          BorderSide(color: Colors.teal), // Teal for focused border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
              color: Colors.grey.shade300), // Light grey for enabled border
        ),
        hintStyle: TextStyle(
          color: Colors.grey.shade600, // Medium grey for hint text
          fontFamily: 'Roboto',
        ),
      ),

      // Card theme customization
      cardTheme: CardTheme(
        color: Colors.white, // White card background
        shadowColor: Colors.grey.shade400, // Light grey for card shadow
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),

      // Icon theme customization
      iconTheme: IconThemeData(
        color: Colors.teal, // Use teal for icons
      ),

      // Chip theme customization
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade200,
        // Light grey chip background
        disabledColor: Colors.grey.shade300,
        selectedColor: Colors.teal, // Use teal for selected chips
        secondarySelectedColor: Colors.grey.shade500,
        // Dark grey for secondary selection
        padding: EdgeInsets.all(8),
        labelStyle: TextStyle(
          color: Colors.black, // Black for chip label
          fontFamily: 'Roboto',
        ),
        secondaryLabelStyle: TextStyle(
          color: Colors.black, // Black for secondary chip label
          fontFamily: 'Roboto',
        ),
        brightness: Brightness.light,
      ),

      // Slider theme customization
      sliderTheme: SliderThemeData(
        activeTrackColor: Colors.teal, // Use teal for active track
        inactiveTrackColor: Colors.grey.shade300, // Light grey for inactive track
        thumbColor: Colors.teal, // Teal for thumb
        overlayColor: Colors.teal.withOpacity(0.2), // Teal for overlay
        valueIndicatorColor: Colors.teal, // Use teal for value indicator
      ),

      // Switch theme customization
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(Colors.teal), // Teal for thumb
        trackColor: MaterialStateProperty.all(
            Colors.grey.shade400), // Light grey for track
      ),

      // Checkbox theme customization
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(Colors.teal), // Teal for checkbox fill
        checkColor: MaterialStateProperty.all(Colors.white), // White for checkmark
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Radio theme customization
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all(Colors.teal), // Use teal for radio button fill
      ),

      // Bottom navigation bar theme customization
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white, // White for background
        selectedItemColor: Colors.teal, // Teal for selected item
        unselectedItemColor: Colors.grey.shade400, // Light grey for unselected items
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.teal, // Teal text for selected label
          fontFamily: 'Roboto',
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade400, // Light grey for unselected label
          fontFamily: 'Roboto',
        ),
        elevation: 8, // Add elevation for a more professional look
      ),
    );
  }

  // Define the gradient
  static LinearGradient get lightWhiteGradient => LinearGradient(
    colors: [
      Colors.white,
      Colors.grey.shade200,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color get secondaryColor =>
      Colors.grey.shade200; // Getter for secondary color
}
