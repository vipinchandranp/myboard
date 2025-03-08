import 'package:flutter/material.dart';
import 'package:myboard/screens/introduction/splash_screen.dart';
import 'package:myboard/themes/app_theme.dart';
import 'config/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Screen',
      initialRoute: '/',
      routes: AppRoutes.getRoutes(),
      debugShowCheckedModeBanner: false, // Disable the debug banner
      theme: AppTheme.lightTheme,
      home: const SplashScreen(), // Set the SplashScreen as the home screen
    );
  }
}
