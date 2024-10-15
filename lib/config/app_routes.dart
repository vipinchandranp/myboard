import 'package:flutter/material.dart';
import 'package:myboard/screens/user/login_screen.dart';

import '../screens/home/home_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/home': (context) => HomeScreen(context),
      '/settings': (context) => SettingsScreen(),
      '/logout': (context) => LoginScreen()
    };
  }
}
