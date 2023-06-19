import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/user/user_event.dart';
import 'package:myboard/bloc/user/user_state.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/models/login_response.dart';
import 'package:myboard/repositories/user_repository.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit(this.userRepository) : super(UserInitial());

  Future<void> signUp(String email, String password, String name) async {
    emit(UserLoading());

    try {
      MyBoardUser user = await userRepository.signUp(email, password, name);
      emit(UserAuthenticated(user));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> signIn(BuildContext context, String username, String password) async {
    emit(UserLoading());

    try {
      LoginResponse response = await userRepository.signIn(username, password);
      MyBoardUser user = response.user;
      emit(UserAuthenticated(user));

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      emit(UserError(message: 'Failed to login. Please try again.'));
    }
  }
}
