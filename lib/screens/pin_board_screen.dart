import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/models/board-id-title.dart';
import 'package:myboard/screens/board_details_screen.dart';

class PinBoardScreen extends StatefulWidget {
  @override
  _PinBoardScreenState createState() => _PinBoardScreenState();
}

class _PinBoardScreenState extends State<PinBoardScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Timer _timer;
  BoardIdTitle? selectedBoard;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<BoardCubit>().fetchTitleAndIdData();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      // Update countdown logic here
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _selectItem(BoardIdTitle board) {
    setState(() {
      selectedBoard = board;
    });

    final String boardId = board.id;
    context.read<BoardCubit>().getBoardImageById(boardId);
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        // Handle keyboard events if needed
      },
      child: BlocConsumer<BoardCubit, BoardState>(
        listener: (context, state) {
          // Handle state changes if needed
        },
        builder: (context, state) {
          if (state is BoardItemsTitleLoaded) {
            final List<BoardIdTitle> boards = state.boardItemsTitle;

            return Scaffold(
              body: Row(
                children: [
                  Container(
                    width: 250.0,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey.shade300),
                      ),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey.shade200],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: boards.length,
                            itemBuilder: (context, index) {
                              final BoardIdTitle board = boards[index];
                              return GestureDetector(
                                onTap: () {
                                  _selectItem(board);
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    color: selectedBoard == board
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: selectedBoard == board
                                        ? [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(0, 3),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: ListTile(
                                    title: Text(board.title),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {

            return Center(
                child: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: selectedBoard != null
                    ? state is BoardImageLoaded
                        ? (state as BoardImageLoaded).imageBytes != null
                            ? BoardDetailsScreen(
                                board: selectedBoard!,
                                imageBytes:
                                    (state as BoardImageLoaded).imageBytes!,
                              )
                            : Center(
                                child: Text('No image details available'),
                              )
                        : Center(
                            child: CircularProgressIndicator(),
                          )
                    : Center(
                        child: Text('Select an item from the list'),
                      ),
              ),
            ));
          }
        },
      ),
    );
  }
}
