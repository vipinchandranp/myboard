import 'package:flutter/material.dart';
import 'package:myboard/themes/app_theme.dart';
import 'login/login_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Screen',
      debugShowCheckedModeBanner: false,  // Disable the debug banner
      theme: AppTheme.lightTheme,
      home: LoginScreen(),  // Set the LoginScreen as the home screen
    );
  }
}
