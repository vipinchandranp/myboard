import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/user/user_cubit.dart';
import 'package:myboard/repositories/board_repository.dart';
import 'package:myboard/repositories/user_repository.dart';
import 'package:myboard/screens/ad_creation_screen.dart';
import 'package:myboard/screens/change_password_screen.dart';
import 'package:myboard/screens/home_screen.dart';
import 'package:myboard/screens/login_screen.dart';
import 'package:myboard/screens/play_screen.dart';
import 'package:myboard/screens/profile_screen.dart';
import 'package:myboard/screens/settings_screen.dart';
import 'package:myboard/screens/signup_screen.dart';
import 'package:myboard/screens/update_profile_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userRepository = UserRepository();
  final boardRepository = BoardRepository();

  await initializeDateFormatting('en');
  await initializeDateFormatting('ar');

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider<BoardRepository>.value(value: boardRepository),
      RepositoryProvider<UserRepository>.value(value: userRepository),
      // Add more repositories if needed.
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<BoardCubit>(
          create: (context) => BoardCubit(context.read<BoardRepository>()),
        ),
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(
            userRepository: context.read<UserRepository>(),
          ),
        ),
        // Add more Cubits or BLoCs if needed.
      ],
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserCubit(userRepository: context.read<UserRepository>()),
      child: MaterialApp(
        title: 'MyBoard',
        routes: {
          '/home': (context) => HomeScreen(),
          '/settings': (context) => SettingsScreen(),
          '/change_password': (context) => ChangePasswordScreen(),
          '/update_profile': (context) => UpdateProfileScreen(),
          '/profile': (context) => ProfileScreen(),
          '/ad_creation': (context) => AdCreationScreen(),
          '/play': (context) => PlayScreen(),
          '/signup': (context) => SignupScreen(),
          '/login': (context) => LoginScreen(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProgressOverlay(
          child: Scaffold(
            body: LoginScreen(),
          ),
        ),
      ),
    );
  }
}

class ProgressOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  ProgressOverlay({
    required this.child,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
