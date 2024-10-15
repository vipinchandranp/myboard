class CitiesResponse {
  final String cityName; // The name of the city
  final double latitude;  // Latitude of the city
  final double longitude; // Longitude of the city

  // Constructor
  CitiesResponse({
    required this.cityName,
    required this.latitude,
    required this.longitude,
  });

  // Factory method to create a CitiesResponse object from JSON
  factory CitiesResponse.fromJson(Map<String, dynamic> json) {
    return CitiesResponse(
      cityName: json['cityName'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  // Method to convert a CitiesResponse object to JSON
  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return 'CitiesResponse(cityName: $cityName, latitude: $latitude, longitude: $longitude)';
  }
}
