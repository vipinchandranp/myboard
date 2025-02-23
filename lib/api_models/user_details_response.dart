class UserProfileResponse {
  final String email;
  final String firstName;
  final String lastName;
  final int? phone;
  final String? address;
  final String? cityName;
  final String? profilePicName;
  final double? latitude;
  final double? longitude;

  UserProfileResponse({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.address,
    this.cityName,
    this.profilePicName,
    this.latitude,
    this.longitude,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'],
      address: json['address'],
      cityName: json['cityName'],
      profilePicName: json['profilePicName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
