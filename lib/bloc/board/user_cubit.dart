import 'package:bloc/bloc.dart';
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
      // Example: userRepository.signup(username, password, email);

      // Emit the signup success state
      emit(UserSignupSuccess());
    } catch (e) {
      // Handle signup error
      emit(UserSignupError(e.toString()));
    }
  }
}
