import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myboard/screens/user/signup_screen.dart';
import '../../api_models/user_login_request.dart';
import '../../repository/user_repository.dart';
import '../home/home_screen.dart';
import '../play/play_widget.dart'; // Import PlayWidget here
import '../../themes/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final List<TextEditingController> _pinControllers = List.generate(6, (_) => TextEditingController()); // Assuming PIN length is 6
  late UserService _userService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userService = UserService(context);
  }

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String displayPin = _pinControllers.map((controller) => controller.text).join(); // Combine all PIN digits

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
      displayPin: displayPin, // Include the Display PIN in the request
    );

    try {
      await _userService.login(userLoginRequest);

      // Navigate based on whether displayPin is provided or not
      if (displayPin.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PlayWidget(displayPin: displayPin)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(context)),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void _onFieldChanged(int index, String value) {
    // If user enters a value, move to the next field
    if (value.isNotEmpty && index < _pinControllers.length - 1) {
      FocusScope.of(context).requestFocus(FocusNode());
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  // Intercept paste action and fill the fields accordingly
  void _onPinPaste(String pastedValue) {
    // Ensure the pasted value fits the PIN length
    String pin = pastedValue.substring(0, 6).padRight(6, '');  // Make sure it doesn't exceed 6 characters

    for (int i = 0; i < pin.length; i++) {
      _pinControllers[i].text = pin[i];
    }
  }

  void _prepopulatePin() {
    // Prepopulate the PIN fields with "egx3Hy" or any other value
    String pin = "egx3Hy";
    for (int i = 0; i < pin.length; i++) {
      _pinControllers[i].text = pin[i];
    }
  }

  void _clearPin() {
    // Clear the PIN fields
    for (int i = 0; i < _pinControllers.length; i++) {
      _pinControllers[i].clear();
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
                Text(
                  'Email or Phone',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Password',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                const SizedBox(height: 24),


                // Forgot Password button placed above Display PIN
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
                const SizedBox(height: 16),

                // Display PIN field with OTP-like input
                Text(
                  'Display PIN (Optional)',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    color: AppTheme.lightTheme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 40,
                      child: TextField(
                        controller: _pinControllers[index],
                        onChanged: (value) => _onFieldChanged(index, value),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        onEditingComplete: () {
                          // Automatically move to the next field on paste or manual entry
                          if (_pinControllers[index].text.length == 1 && index < 5) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '-',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),

                // Prepopulate Pin and Clear Pin Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _prepopulatePin,
                      child: const Text("Prepopulate PIN"),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _clearPin,
                      child: const Text("Clear PIN"),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Login button
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
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen()),
                      );
                    },
                    child: const Text(
                      'Create an Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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
