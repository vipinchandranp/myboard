import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Correct import for flutter_svg

import '../utils/Constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // App logo and title
                Center(
                  child: SvgPicture.asset(
                    'assets/myboard_logo_round.png',
                    width: 100,
                    height: 100,
                  ),
                ),

                const SizedBox(height: 16),

                // Delivery boy illustration
                Center(
                  child: Image.asset(
                    'assets/myboard_logo_round.png', // Replace with your image
                    width: 200,
                    height: 200,
                  ),
                ),

                const SizedBox(height: 24),

                // Email or Phone field
                TextField(
                  decoration: InputDecoration(
                    hintText: emailOrPhoneHint,
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200], // Light background for text field
                  ),
                ),

                const SizedBox(height: 16),

                // Password field
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: passwordHint,
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200], // Light background for text field
                  ),
                ),

                const SizedBox(height: 16),

                // Forgot Password? link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Handle forgot password logic
                    },
                    child: Text(
                      forgotPasswordText,
                      style: TextStyle(color: Colors.blue), // Adjust color
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle login logic
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.blue, // Primary color
                    ),
                    child: const Text(
                      loginButtonText,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Create an account button
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Handle create account logic
                    },
                    child: Text(
                      createAccountText,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue, // Adjust color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
