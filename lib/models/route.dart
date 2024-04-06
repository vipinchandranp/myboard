import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteModel {
  final String? id; // Add id field
  final String name;
  final List<LatLng> locations;

  RouteModel({
    this.id,
    required this.name,
    required this.locations,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include id in the JSON representation
      'name': name,
      'locations': locations.map((latLng) => {
        'latitude': latLng.latitude,
        'longitude': latLng.longitude,
      }).toList(),
    };
  }

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'], // Retrieve id from JSON
      name: json['name'],
      locations: (json['locations'] as List<dynamic>).map((location) {
        return LatLng(
          location['latitude'],
          location['longitude'],
        );
      }).toList(),
    );
  }
}
