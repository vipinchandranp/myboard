import 'package:equatable/equatable.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/models/location_search.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoadSuccess extends MapState {
  final Iterable<String> places;

  MapLoadSuccess({required this.places});

  @override
  List<Object?> get props => [places];
}

class MapLoadFailure extends MapState {
  final String error;

  MapLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class SearchLocationSuccess extends MapState {
  final Iterable<String> searchResults;

  SearchLocationSuccess({required this.searchResults});

  @override
  List<Object?> get props => [searchResults];
}

class SearchLocationLoading extends MapState {
  @override
  List<Object?> get props => [];
}

class SelectedLocation extends MapState {
  final SelectLocationDTO selectedLocation;

  SelectedLocation({required this.selectedLocation});

  @override
  List<Object?> get props => [selectedLocation];
}

// New state for displaying nearby displays
class MapLoadDisplaysNearby extends MapState {
  final Iterable<DisplayDetails> displays;

  MapLoadDisplaysNearby({required this.displays});

  @override
  List<Object?> get props => [displays];
}
