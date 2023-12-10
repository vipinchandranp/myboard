import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/notification_state.dart';

class CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        return Text(
          'Counter Value: ${context.read<NotificationCubit>().counterValue}',
          style: TextStyle(fontSize: 24),
        );
      },
    );
  }
}

class NotificationIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        return Row(
          children: [
            Icon(Icons.notification_important,
                color: state == NotificationState.incerement
                    ? Colors.green
                    : Colors.transparent),
            Icon(Icons.notification_important,
                color: state == NotificationState.decrement
                    ? Colors.red
                    : Colors.transparent),
          ],
        );
      },
    );
  }
}


class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter App with Cubit'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CounterDisplay(),
            SizedBox(height: 16),
            NotificationIcons(),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<NotificationCubit>().incrementCounter(),
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => context.read<NotificationCubit>().decrementCounter(),
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
