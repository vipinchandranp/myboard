import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/user/user_cubit.dart';
import 'package:myboard/bloc/user/user_state.dart';
import 'package:myboard/models/user.dart';

class UserUtils {
  static MyBoardUser? getLoggedInUser(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final userState = userCubit.state;

    if (userState is UserAuthenticated) {
      return userState.user;
    } else {
      return null;
    }
  }
}
