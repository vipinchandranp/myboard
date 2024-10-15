class UserDetailsRequest {
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final int? phone;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? cityName;

  UserDetailsRequest({
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.cityName
  });

  // Method to convert the UserDetailsRequest object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'cityName': cityName,
    };
  }

  // Method to create a UserDetailsRequest object from JSON
  factory UserDetailsRequest.fromJson(Map<String, dynamic> json) {
    return UserDetailsRequest(
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      cityName: json['cityName'],
    );
  }
}
