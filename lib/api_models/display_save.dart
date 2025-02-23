import 'dart:io';

class SaveDisplay {
  final String displayName;
  final double? price;
  final double? latitude;
  final double? longitude;
  final List<File> files;

  SaveDisplay({
    required this.displayName,
    this.price,
    this.latitude,
    this.longitude,
    required this.files,
  });

  // Converts this SaveDisplay instance into JSON format
  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'price': price,
      'latitude': latitude,
      'longitude': longitude,
      'files': files.map((file) => file.path).toList(),
    };
  }
}
