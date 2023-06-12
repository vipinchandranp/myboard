import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myboard/models/board.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/board/board_state.dart';

class PlayLiveScreen extends StatefulWidget {
  @override
  _PlayLiveScreenState createState() => _PlayLiveScreenState();
}

class _PlayLiveScreenState extends State<PlayLiveScreen> {
  late Board? currentBoard;

  @override
  void initState() {
    super.initState();
    currentBoard = getCurrentBoard();
  }

  Board? getCurrentBoard() {
    final now = DateTime.now();
    final boardCubit = context.read<BoardCubit>();
    final boardState = boardCubit.state;
    if (boardState is BoardLoaded) {
      final boards = boardState.boards;
      for (final board in boards) {
        final timeSlots = board.displayDateTimeMap.values.toList();
        for (final timeSlot in timeSlots) {
          final startTime = DateTime(
            now.year,
            now.month,
            now.day,
            timeSlot.startTime.hour,
            timeSlot.startTime.minute,
          );
          final endTime = DateTime(
            now.year,
            now.month,
            now.day,
            timeSlot.endTime.hour,
            timeSlot.endTime.minute,
          );
          if (now.isAfter(startTime) && now.isBefore(endTime)) {
            return board;
          }
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (currentBoard != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Playing Live'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Playing board:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              currentBoard!.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              currentBoard!.description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Playing Live'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Scan QR Code to display your board',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Image.asset(
                'assets/qr_code.png', // Replace with your QR code image path
                width: 200,
                height: 200,
              ),
            ],
          ),
        ),
      );
    }
  }
}
