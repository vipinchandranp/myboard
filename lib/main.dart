import 'package:flutter/material.dart';
import 'package:myboard/screens/user/login_screen.dart';
import 'package:myboard/themes/app_theme.dart';

import 'config/app_routes.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Screen',
      initialRoute: '/',
      routes: AppRoutes.getRoutes(),
      debugShowCheckedModeBanner: false,  // Disable the debug banner
      theme: AppTheme.lightTheme,
      home: LoginScreen(),  // Set the LoginScreen as the home screen
    );
  }
}
