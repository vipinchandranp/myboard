import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:myboard/models/route.dart';
import 'package:myboard/repositories/route-repository.dart';

part 'route_state.dart';

class RouteCubit extends Cubit<RouteState> {
  final RouteRepository _repository;

  RouteCubit(this._repository) : super(RouteInitial());

  void saveRoute(BuildContext buildContext, RouteModel route) {
    _repository.saveRoute(buildContext, route);
    emit(RouteSaved());
  }
}
