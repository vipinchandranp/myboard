class SelectLocationDTO {
  String name;
  double latitude;
  double longitude;

  SelectLocationDTO({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory SelectLocationDTO.fromJson(Map<String, dynamic> json) {
    return SelectLocationDTO(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return 'SelectLocationDTO{name: $name, latitude: $latitude, longitude: $longitude}';
  }
}
