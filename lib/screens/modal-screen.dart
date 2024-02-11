import 'package:flutter/material.dart';

class ModalManager {
  static void showModal({
    required BuildContext context,
    required Widget widget,
    required String headerText, // Add headerText parameter
    double heightFactor = 0.9,
    double widthFactor = 0.9,
    Color backgroundColor = Colors.white, // Add backgroundColor parameter
    Color textColor = Colors.white, // Add textColor parameter
    bool isScrollControlled = true,
  }) {
    late OverlayEntry overlayEntry;

    // Create a function to remove the overlay
    void removeOverlay() {
      overlayEntry.remove();
    }

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Modal barrier to prevent interaction with the rest of the screen
          AbsorbPointer(
            absorbing: true, // Prevent interaction with the background
            child: GestureDetector(
              onTap: removeOverlay,
              child: Container(
                color: backgroundColor.withOpacity(0.1),
              ),
            ),
          ),
          // Modal content
          Center(
            child: FractionallySizedBox(
              widthFactor: widthFactor,
              heightFactor: heightFactor,
              child: Material(
                color: Colors.transparent,
                // Set material color to transparent
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.indigo,
                    // Set background color
                    // Transparent app bar
                    elevation: 0,
                    // Remove elevation
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: textColor, // Set back arrow color
                      ),
                      onPressed:
                          removeOverlay, // Close the modal on button press
                    ),
                    title: Text(
                      headerText,
                      style: TextStyle(color: textColor), // Set text color
                    ),
                    actions: [
                      IconButton(
                        icon: Image.asset(
                          'assets/close.png',
                          height: 30, // Set icon height
                          width: 30, // Set icon width
                        ),
                        onPressed: removeOverlay,
                      ),
                    ],
                  ),
                  body: widget,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Insert the overlay entry into the overlay
    Overlay.of(context)!.insert(overlayEntry);
  }
}
