import 'package:bloc/bloc.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/repositories/user_repository.dart';
import 'package:myboard/bloc/user/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit(this.userRepository) : super(UserInitial());

  Future<void> signup(
    String username,
    String password,
    String email,
  ) async {
    try {
// Perform signup logic using the UserRepository
      await userRepository.signUp(username, password, email);
      // Emit the signup success state
      emit(UserSignupSuccess());
    } catch (e) {
      // Handle signup error
      emit(UserSignupError(e.toString()));
    }
  }

  Future<void> login(String username, String password) async {
    final loginResponse = await userRepository.signIn(username, password);
    try {
      if (loginResponse != null) {
        // Emit the user authenticated state with the logged in user
        emit(UserAuthenticated(loginResponse.user));
      } else {
        // Emit the user error state if login failed
        emit(UserError(message: 'Login failed. Invalid credentials.'));
      }
    } catch (e) {
      // Handle login error
      emit(UserError(message: e.toString()));
    }
  }
}
