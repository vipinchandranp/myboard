class AuthorizationService {
  Future<String?> getUserRole() async {
    // Simulating a backend API call.
    await Future.delayed(Duration(seconds: 2)); // Simulating network delay.

    // Example: Return user role from API or local storage
    return 'admin'; // In a real-world scenario, this would be dynamic.
  }
}
