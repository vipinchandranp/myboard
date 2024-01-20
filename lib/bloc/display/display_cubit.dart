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

      // Add debugging to identify null values
      displays.forEach((display) {
        print('Display ID: ${display.id}');
        print('Latitude: ${display.latitude}');
        print('Longitude: ${display.longitude}');
        print('Description: ${display.description}');
        print('Name: ${display.displayName}');
        print('FileName: ${display.fileName ?? "null"}'); // Check for null
        print('UserName: ${display.userName ?? "null"}'); // Check for null
        print('Comments: ${display.comments ?? "null"}'); // Check for null
        print('Rating: ${display.rating}');
        print('UserID: ${display.userId ?? "null"}'); // Check for null
        print('Images: ${display.images ?? "null"}'); // Check for null

        // If 'comments' is not null, print details of each comment
        display.comments?.forEach((comment) {
          print('Comment Text: ${comment.text}');
          print('Comment Username: ${comment.username}');
          print('Comment Date: ${comment.date}');

          // If 'replies' is not null, print details of each reply
          comment.replies?.forEach((reply) {
            print('Reply Text: ${reply.text}');
            print('Reply Username: ${reply.username}');
            print('Reply Date: ${reply.date}');
          });
        });

        print('------------------------');
      });

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
