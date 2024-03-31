import 'package:carousel_slider/carousel_slider.dart'; // Import carousel_slider package
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/user/user_cubit.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Sample image list for the carousel
    List<String> images = [
      'assets/myboard_logo_round.png',
      'assets/myboard_logo.png',
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.indigo,
              child: Center(
                child: Text(
                  'Welcome to MyBoard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // Footer
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.indigo,
              child: Center(
                child: Text(
                  'Join MyBoard Today!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // Centered content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Carousel
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 400.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 2.0,
                    ),
                    items: images.map((item) {
                      return Container(
                        child: Center(
                          child: Image.asset(
                            item,
                            fit: BoxFit.cover,
                            height: 200,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.0),
                  // Texts
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section 1
                        Text(
                          'Unleash Your Creativity',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'MyBoard empowers users to unleash their creativity by allowing them to create personalized displays and boards, all seamlessly integrated with dynamic mapping technology.',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        // Section 2
                        Text(
                          'Seamless Connection',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'MyBoard facilitates connection by allowing users to geotag their displays on a map, providing an interactive and engaging experience for viewers.',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        // Section 3
                        Text(
                          'Intuitive Interface',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Our intuitive interface makes the entire process smooth and enjoyable, catering to both beginners and seasoned creators.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right side login section
          Positioned(
            top: 20.0,
            right: 20.0,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(16.0),
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
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserCubit>().signIn(
                            context,
                            _usernameController.text,
                            _passwordController.text,
                          );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white), // Text color
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.indigo, // Button color
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text('Sign Up'),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Or',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Handle Google sign-up here
                    },
                    icon: Icon(Icons.g_translate),
                    label: Text('Login with Google'),
                    style: OutlinedButton.styleFrom(
                        // Add styling as needed
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
