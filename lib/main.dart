  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:myboard/bloc/board/board_cubit.dart';
  import 'package:myboard/bloc/display/display_cubit.dart';
  import 'package:myboard/bloc/map/map_cubit.dart';
  import 'package:myboard/bloc/user/user_cubit.dart';
  import 'package:myboard/repositories/board_repository.dart';
  import 'package:myboard/repositories/display_repository.dart';
  import 'package:myboard/repositories/map_repository.dart';
  import 'package:myboard/repositories/user_repository.dart';
  import 'package:myboard/screens/ad_creation_screen.dart';
  import 'package:myboard/screens/change_password_screen.dart';
  import 'package:myboard/screens/login_screen.dart';
  import 'package:myboard/screens/mainlayout_screen.dart';
  import 'package:myboard/screens/play_screen.dart';
  import 'package:myboard/screens/profile_screen.dart';
  import 'package:myboard/screens/settings_screen.dart';
  import 'package:myboard/screens/signup_screen.dart';
  import 'package:myboard/screens/update_profile_screen.dart';
  import 'package:myboard/utils/token_interceptor.dart';
  import 'package:provider/provider.dart';
  import 'package:get_it/get_it.dart';

  void main() {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize repositories
    final userRepository = UserRepository();
    final boardRepository = BoardRepository();
    final displayRepository = DisplayRepository();
    final googleMapsRepository = MapRepository();

    // Create a global instance of GetIt for dependency injection
    final GetIt getIt = GetIt.instance;

  // Function to set up dependencies
    void setupDependencies() {
      // Register TokenInterceptorHttpClient as a singleton
      getIt.registerSingleton<TokenInterceptorHttpClient>(
          TokenInterceptorHttpClient());
      getIt.registerSingleton<BoardRepository>(BoardRepository());
      getIt.registerSingleton<DisplayRepository>(DisplayRepository());
      getIt.registerSingleton<MapRepository>(MapRepository());
      getIt.registerSingleton<UserRepository>(UserRepository());
      getIt.registerSingleton<BoardCubit>(BoardCubit(boardRepository));
      // You can register other dependencies if needed
      // getIt.registerSingleton<YourServiceClass>(YourServiceClass());
      // getIt.registerFactory<YourFactoryClass>(() => YourFactoryClass());
    }

    setupDependencies();
    runApp(
      MultiBlocProvider(
        providers: [
          Provider<UserRepository>.value(value: userRepository),
          Provider<BoardRepository>.value(value: boardRepository),
          Provider<DisplayRepository>.value(value: displayRepository),
          Provider<MapRepository>.value(value: googleMapsRepository),
          BlocProvider<BoardCubit>(
            create: (context) => BoardCubit(context.read<BoardRepository>()),
          ),
          BlocProvider<UserCubit>(
            create: (context) => UserCubit(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider<DisplayCubit>(
            create: (context) => DisplayCubit(
              context.read<DisplayRepository>(),
            ),
          ),
          BlocProvider<MapCubit>(
            create: (context) => MapCubit(
              mapRepository: context.read<MapRepository>(),
            ),
          ), // Add more Cubits or BLoCs if needed.
        ],
        child: MyApp(),
      ),
    );
  }

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        routes: {
          '/settings': (context) => SettingsScreen(),
          '/change_password': (context) => ChangePasswordScreen(),
          '/update_profile': (context) => UpdateProfileScreen(),
          '/ad_creation': (context) => AdCreationScreen(),
          '/play': (context) => PlayScreen(),
          '/signup': (context) => SignupScreen(),
          '/login': (context) => LoginScreen(),
          '/main': (context) => MainScreen(), // Use MyBoardScreen here
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primarySwatch: createCustomSwatch(Color(0xFF7986CB))),
        home: ProgressOverlay(
          child: Scaffold(
            body: LoginScreen(),
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

  MaterialColor createCustomSwatch(Color color) {
    // Generate shades for the custom primary color
    Map<int, Color> colorMap = {
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    };

    // Create and return the custom primary swatch
    return MaterialColor(color.value, colorMap);
  }
