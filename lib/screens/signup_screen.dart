import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myboard/config/api_config.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String _selectedCountryCode = '+1'; // Default country code
  bool _isLoading = false;

  Future<void> _signup() async {
    // Reset previous error states
    setState(() {
      _isLoading = true;
    });

    String username = _usernameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String email = _emailController.text;
    String phoneNumber = _selectedCountryCode + _phoneNumberController.text;

    // Perform basic form validation
    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog('All fields are required.');
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      _showErrorDialog('Passwords do not match.');
      return;
    }

    // Validate phone number
    if (!_isValidPhoneNumber(phoneNumber)) {
      //_showErrorDialog('Invalid phone number.');
      //return;
    }

    // Additional validation for email can be added here

    // Make API request to create the user
    try {
      var response = await http.post(
        Uri.parse(APIConfig.getRootURL() + '/v1/users/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
          'phone': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        _showSuccessDialog('User created successfully.');
        Navigator.of(context).pushNamed('/login');
      } else {
        _showErrorDialog('Failed to create user.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters from the phone number
    String cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Validate if the cleaned phone number has exactly 10 digits
    return RegExp(r'^\d{10}$').hasMatch(cleanedPhoneNumber);
  }



  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5, // 3/4 of the screen width
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0), // Decreased top padding and increased bottom padding
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Adjusted mainAxisSize
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Container(
                    width: 100,
                    child: DropdownButton<String>(
                      value: _selectedCountryCode,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCountryCode = value!;
                        });
                      },
                      items: ['+1', '+91', '+44', '+81'] // Add more country codes as needed
                          .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0, // Adjusted horizontal padding
                  ),
                  // Remove color to use the default button color
                ),
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
