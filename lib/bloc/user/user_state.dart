import 'package:equatable/equatable.dart';
import 'package:myboard/models/user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
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
