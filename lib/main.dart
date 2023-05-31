import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/user/user_cubit.dart';
import 'package:myboard/repositories/user_repository.dart';
import 'package:myboard/screens/home_screen.dart';
import 'package:myboard/screens/login_screen.dart';
import 'package:myboard/screens/signup_screen.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(UserRepository()),
      child: MaterialApp(
        title: 'MyBoard',
        routes: {
          '/home': (context) => HomeScreen(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
