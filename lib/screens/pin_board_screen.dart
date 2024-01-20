import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:myboard/models/board-id-title.dart';
import 'package:myboard/repositories/board_repository.dart';

import 'board_details_screen.dart';

class PinBoardScreen extends StatefulWidget {
  @override
  _PinBoardScreenState createState() => _PinBoardScreenState();
}

class _PinBoardScreenState extends State<PinBoardScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Timer _timer;
  BoardIdTitle? selectedBoard;
  final ScrollController _scrollController = ScrollController();
  final BoardRepository boardRepository = BoardRepository();
  late Future<List<BoardIdTitle>> boardsFuture;
  late List<BoardIdTitle> boards; // Initialize the list

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      // Update countdown logic here
    });

    // Load initial board items
    boardsFuture = _loadInitialBoards();
  }

  Future<List<BoardIdTitle>> _loadInitialBoards() async {
    try {
      List<BoardIdTitle> initialBoards = await boardRepository.getTitleAndId();
      setState(() {
        boards = initialBoards;
        // Select the first item in the list by default
        if (initialBoards.isNotEmpty) {
          selectedBoard = initialBoards.first;
        }
      });
      return initialBoards;
    } catch (e) {
      print('Failed to fetch initial board details: $e');
      throw e;
    }
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side: List of board items
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
                FutureBuilder<List<BoardIdTitle>>(
                  future: boardsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No board items available');
                    } else {
                      List<BoardIdTitle> boards = snapshot.data!;
                      return Expanded(
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
                                ),
                                child: ListTile(
                                  title: Text(board.title),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          // Right side: Details screen
          Expanded(
            child: selectedBoard != null
                ? BoardDetailsScreen(board: selectedBoard!)
                : Container(),
          ),
        ],
      ),
    );
  }
}
