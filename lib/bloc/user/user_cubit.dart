import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/user/user_event.dart';
import 'package:myboard/bloc/user/user_state.dart';
import 'package:myboard/models/my_board_user.dart';
import 'package:myboard/repositories/user_repository.dart';


class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit(this.userRepository) : super(UserInitial());

  Future<void> signUp(String email, String password, String name, String phoneNumber) async {
    emit(UserLoading());

    try {
      MyBoardUser user = await userRepository.signUp(email, password, name, phoneNumber);
      emit(UserAuthenticated(user));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> login(BuildContext context, String username, String password) async {
    //emit(UserLoading());

    try {
      // Simulating an asynchronous login process
      //await Future.delayed(Duration(seconds: 2));

      // Replace this with your actual authentication logic
      // For example, calling a method in UserRepository
      //final user = await userRepository.authenticate(username, password);

      // If authentication is successful, emit UserAuthenticated state
      //emit(UserAuthenticated(user));

      // Navigate to the home screen
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // If authentication fails, emit UserError state
      emit(UserError(message: 'Failed to login. Please try again.'));
    }
  }

}
