import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Import to detect platform
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myboard/screens/user/signup_screen.dart';
import '../../api_models/user_login_request.dart';
import '../../repository/user_repository.dart';
import '../home/home_screen.dart';
import '../display/enter_display_pin.dart';
import '../../themes/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late UserService _userService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userService = UserService(context);
  }

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in both fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userLoginRequest = UserLoginRequest(
      username: username,
      password: password,
    );

    try {
      await _userService.login(userLoginRequest);

      // If login is successful, navigate to EnterDisplayPinWidget
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(context)),
      );
    } catch (e) {
      // Handle login failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login failed, please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loginAsDisplay() async {
    // Call _login function first
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in both fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userLoginRequest = UserLoginRequest(
      username: username,
      password: password,
    );

    try {
      // Attempt to login
      await _userService.login(userLoginRequest);

      // If login is successful, navigate to EnterDisplayPinWidget
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EnterDisplayPinWidget()),
      );
    } catch (e) {
      // Handle login failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login failed, please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Center(
                  child: SvgPicture.asset(
                    'assets/display_icon.png',
                    height: 100,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Image.asset(
                    'assets/display_icon.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 32),
                // Show Login Screen only on mobile
                if (!kIsWeb) ...[
                  // Email or Phone Field (Mobile)
                  Text(
                    'Email or Phone',
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.lightTheme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email or phone',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Password Field (Mobile)
                  Text(
                    'Password',
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.lightTheme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Forgot Password Button (Mobile)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle forgot password logic
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Login Button (Mobile)
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: AppTheme.lightTheme.primaryColor,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
                // Show 'Login as Display' Button only in browser (Web)
                if (kIsWeb) ...[
                  const SizedBox(height: 24),
                  // Username Field (Web)
                  Text(
                    'Username',
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.lightTheme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email or username',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Password Field (Web)
                  Text(
                    'Password',
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.lightTheme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                  // 'Login as Display' Button (Web)
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _loginAsDisplay,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text(
                        'Login as Display',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
