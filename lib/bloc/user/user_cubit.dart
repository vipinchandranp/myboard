import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/user/user_state.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/models/location_search.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/repositories/user_repository.dart';
import 'package:myboard/screens/screen-util/screen_util_loading.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit({
    required this.userRepository,
  }) : super(UserInitial()) {}

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

  Future<void> signIn(
      BuildContext context, String username, String password) async {
    LoadingHelper.showLoading(context);
    emit(UserLoading());

    try {
      String response = await userRepository.signIn(username, password);

      // Fetch board items for the logged-in user

      LoadingHelper.hideLoading(context);
      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      emit(UserError(message: 'Failed to login. Please try again.'));
    } finally {}
  }

  Future<void> saveDisplay(
      BuildContext context, DisplayDetails displayDetails) async {
    emit(UserLoading());

    try {
      await userRepository.saveDisplay(context, displayDetails);
      emit(DisplaySaved()); // Emit DisplaySaved state upon successful saving
    } catch (e) {
      emit(UserError(message: 'Failed to save display: $e'));
    }
  }

  Future<void> deleteDisplay(BuildContext context, String displayId) async {
    emit(UserLoading());

    try {
      await userRepository.deleteDisplay(context, displayId);
      emit(
          DisplayDeleted()); // Emit DisplayDeleted state upon successful deletion
    } catch (e) {
      emit(UserError(message: 'Failed to delete display: $e'));
    }
  }

  Future<void> saveSelectedLocation(
      BuildContext context, SelectLocationDTO selectedLocation) async {
    emit(UserLoading());

    try {
      // Assuming userRepository is an instance of UserRepository
      await userRepository.saveLocation(selectedLocation);
      emit(
          SelectedLocationSaved()); // Emit LocationSaved state upon successful saving
    } catch (e) {
      emit(UserError(message: 'Failed to save location: $e'));
    }
  }
  Future<void> initLocation() async {
    emit(UserLoading());

    try {
      // Fetch the user's information, including the initial location
      MyBoardUser user = await userRepository.initUser();

      // Check if the user has a selected location
      if (user.location != null) {
        emit(UserAuthenticated(user));
      } else {
        // If the user doesn't have a selected location, handle it as needed
        emit(UserError(message: 'User has no selected location'));
      }
    } catch (e) {
      emit(UserError(message: 'Failed to fetch user information: $e'));
    }
  }


}
