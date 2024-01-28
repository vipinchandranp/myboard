import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/display/display_state.dart';
import 'package:myboard/repositories/display_repository.dart';

class DisplayCubit extends Cubit<DisplayState> {
  final DisplayRepository displayRepository;

  DisplayCubit(this.displayRepository) : super(DisplayLoading());
  Future<void> getAllDisplays() async {
    try {
      emit(DisplayLoading());
      final displays = await displayRepository.getAllDisplays();

      emit(DisplayLoaded(displays));
    } catch (e) {
      emit(DisplayError('Failed to fetch displays.'));
    }
  }


  Future<void> getDisplaysForLoggedInUser() async {
    try {
      emit(DisplayLoading());
      final displays = await displayRepository.getDisplaysForLoggedInUser();
      emit(DisplayLoaded(displays));
    } catch (e) {
      emit(DisplayError('Failed to fetch displays for user.'));
    }
  }

// Add other methods as needed
}
