import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myboard/models/display_details.dart';

abstract class DisplayState extends Equatable {
  const DisplayState();

  @override
  List<Object> get props => [];
}

class DisplayLoading extends DisplayState {}

class DisplayLoaded extends DisplayState {
  final List<DisplayDetails> displays;

  const DisplayLoaded(this.displays);

  @override
  List<Object> get props => [displays];
}

class DisplayError extends DisplayState {
  final String message;

  const DisplayError(this.message);

  @override
  List<Object> get props => [message];
}
