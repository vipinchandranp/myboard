import 'package:equatable/equatable.dart';
import 'package:myboard/models/user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}
class UserInitLocation extends UserState {
  final MyBoardUser user; // Include the user data in the initial state

  const UserInitLocation(this.user);

  @override
  List<Object?> get props => [user];
}

class UserLoading extends UserState {}

class UserInitial extends UserState {}

class UserAuthenticated extends UserState {
  final MyBoardUser user;

  const UserAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserSignupSuccess extends UserState {}

class UserSignupError extends UserState {
  final String errorMessage;

  const UserSignupError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class DisplaySaved extends UserState {
  const DisplaySaved();

  @override
  List<Object?> get props => [];
}

class DisplayDeleted extends UserState {
  const DisplayDeleted();

  @override
  List<Object?> get props => [];
}
class SelectedLocationSaved extends UserState {
  const SelectedLocationSaved();

  @override
  List<Object?> get props => [];
}