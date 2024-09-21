class UserSignupRequest {
  final String? username;
  final String password;
  final String email;
  final String? firstName;
  final String? lastName;
  final int? phone;

  UserSignupRequest({
    this.username,
    required this.password,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
  });

  // Convert JSON to UserSignupRequest
  factory UserSignupRequest.fromJson(Map<String, dynamic> json) {
    return UserSignupRequest(
      username: json['username'],
      password: json['password'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
    );
  }

  // Convert UserSignupRequest to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
    };
  }
}
