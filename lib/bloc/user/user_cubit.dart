import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/user/user_event.dart';
import 'package:myboard/bloc/user/user_state.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/models/login_response.dart';
import 'package:myboard/repositories/user_repository.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/screens/custom_dialog.dart';
import 'package:myboard/screens/loading.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit({
    required this.userRepository,
  }) : super(UserInitial()) {

  }

  Future<void> signInWithGoogle() async {
    // Your Google Sign-In logic here
  }

  Future<List<String>> getAvailableUsers(String pattern) async {
    try {
      if (pattern == null) {
        throw Exception("No authenticated user found");
      }
      List<String> userList = await userRepository.getAvailableUsers(pattern);
      return userList;
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      throw Exception('Failed to fetch users');
    }
  }


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
    LoadingHelper.showLoading(context);
    emit(UserLoading());

    try {
      String response = await userRepository.signIn(username, password);

      // Fetch board items for the logged-in user

      LoadingHelper.hideLoading(context);
      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      emit(UserError(message: 'Failed to login. Please try again.'));
    }finally{
    }
  }
}
