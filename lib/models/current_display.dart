import 'display_details.dart';

class CurrentDisplay {
  // Singleton instance
  static final CurrentDisplay _instance = CurrentDisplay._internal();

  // Private constructor
  CurrentDisplay._internal();

  // Getter to access the instance
  static CurrentDisplay get instance => _instance;

  // Current display value
  DisplayDetails? _currentDisplay;

  // Getter for current display
  DisplayDetails? get currentDisplay => _currentDisplay;

  // Setter for current display
  set currentDisplay(DisplayDetails? display) {
    _currentDisplay = display;
  }
}
