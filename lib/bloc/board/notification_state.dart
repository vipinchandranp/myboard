import 'package:flutter_bloc/flutter_bloc.dart';
enum NotificationState{ initial, incerement, decrement}

class NotificationCubit extends Cubit<NotificationState> {
  int _counter = 0;
  NotificationCubit() : super(NotificationState.initial);
  int get counterValue => _counter;

  void incrementCounter() {
    _counter++;
    emit(NotificationState.incerement);
  }

  void decrementCounter() {
    _counter--;
    emit(NotificationState.decrement);
  }

}
