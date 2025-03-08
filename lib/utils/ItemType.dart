enum ItemType {
  DISPLAY,  // Represents display content
  BOARD,    // Represents board content
}

extension ItemTypeExtension on ItemType {
  /// Converts a string to the corresponding `ItemType` enum.
  static ItemType fromJson(String type) {
    switch (type) {
      case 'DISPLAY':
        return ItemType.DISPLAY;
      case 'BOARD':
        return ItemType.BOARD;
      default:
        throw ArgumentError('Invalid ItemType: $type');
    }
  }

  /// Converts the `ItemType` enum to its string representation.
  String toJson() {
    return toString().split('.').last; // e.g., ItemType.DISPLAY -> "DISPLAY"
  }
}
