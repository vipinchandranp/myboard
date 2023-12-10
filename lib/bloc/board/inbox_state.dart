import 'package:flutter_bloc/flutter_bloc.dart';

class InboxState {
  final bool hasNotifications;

  InboxState(this.hasNotifications);
}

class InboxCubit extends Cubit<InboxState> {
  InboxCubit(super.initialState);

  void markNotificationAsRead() {
    emit(InboxState(false));
  }

  void receiveNewNotification() {
    emit(InboxState(true));
  }
}
