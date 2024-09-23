import 'package:flutter/material.dart';
import 'package:myboard/screens/board/view_board_details.dart';
import 'package:myboard/screens/home/home_screen.dart';
import '../../models/board/board.dart';
import '../../repository/board_repository.dart';
import 'board_card.dart';

class ViewBoardsWidget extends StatefulWidget {
  @override
  _ViewBoardsWidgetState createState() => _ViewBoardsWidgetState();
}

class _ViewBoardsWidgetState extends State<ViewBoardsWidget> {
  late final BoardService _boardService;
  List<Board> _boards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    _boardService = BoardService(context);
    await _fetchBoards();
  }

  Future<void> _fetchBoards() async {
    try {
      final boards = await _boardService.getBoards();
      setState(() {
        _boards = boards ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching boards: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Boards'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBoardList(),
    );
  }

  Widget _buildBoardList() {
    if (_boards.isEmpty) {
      return const Center(child: Text('No boards found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _boards.length,
      itemBuilder: (context, index) {
        final board = _boards[index];
        return BoardCardWidget(
          board: board
        );
      },
    );
  }
}
