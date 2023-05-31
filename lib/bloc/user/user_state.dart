import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myboard/models/my_board_user.dart';
import 'package:myboard/repositories/user_repository.dart';

class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {}

class UserInitial extends UserState {
  const UserInitial();

  @override
  List<Object> get props => [];
}

class UserAuthenticated extends UserState {
  final MyBoardUser user;

  UserAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;

  UserError({required this.message});

  @override
  List<Object> get props => [message];
}
