import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/map/map_state.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/models/location_search.dart'; // Make sure to import the correct file
import 'package:myboard/repositories/map_repository.dart';

class MapCubit extends Cubit<MapState> {
  final MapRepository mapRepository;

  MapCubit({required this.mapRepository}) : super(SearchLocationLoading());

  // Add a method to handle the SearchPlacesEvent
  Future<void> searchPlaces(String query) async {
    try {
      // Fetch data from the repository
      final Iterable<SelectLocationDTO> places =
          await mapRepository.searchPlaces(query);

      // Convert SelectLocationDTO instances to strings
      final Iterable<String> placeNames =
          places.map((location) => location.name).toList();

      // Emit a new state with the search results
      emit(MapLoadSuccess(places: placeNames));
    } catch (e) {
      // Handle errors and emit a failure state
      emit(MapLoadFailure(error: 'Failed to search places'));
    }
  }

  // Method to handle the GetDisplaysNearbyEvent
  Future<void> getDisplaysNearby(SelectLocationDTO location) async {
    try {
      // Fetch data from the repository
      final Iterable<DisplayDetails> displays =
          await mapRepository.getDisplaysNearby(location);

      // Emit a new state with the displays nearby
      emit(MapLoadDisplaysNearby(displays: displays));
    } catch (e) {
      // Handle errors and emit a failure state
      emit(MapLoadFailure(error: 'Failed to get displays nearby'));
    }
  }

// You can add more methods to handle other events and update the state accordingly
}
