import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/models/board_with_image.dart';
import 'package:myboard/screens/Insights/main_insight_screen.dart';

class ViewMyboardScreen extends StatefulWidget {
  @override
  _ViewMyboardScreenState createState() => _ViewMyboardScreenState();
}

class _ViewMyboardScreenState extends State<ViewMyboardScreen> {
  final ScrollController _scrollController = ScrollController();
  late BoardCubit _boardCubit;

  @override
  void initState() {
    super.initState();
    _boardCubit = GetIt.I<BoardCubit>();
    _boardCubit.fetchBoardItems();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _boardCubit.fetchPaginatedBoardItems(
          _boardCubit.boardsWithImages.length ~/ 10 + 1, 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: BlocBuilder<BoardCubit, BoardState>(
              bloc: _boardCubit,
              builder: (context, state) {
                if (state is BoardLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is BoardLoaded) {
                  return _buildBoardList(state.boardsWithImages);
                } else if (state is BoardError) {
                  return Center(child: Text(state.message));
                } else if (state is BoardSaved) {
                  // Handle BoardSaved state if needed
                  return Center(child: Text('Board Saved'));
                } else if (state is BoardDisplaysLoaded) {
                  // Handle BoardDisplaysLoaded state if needed
                  return Center(child: Text('Displays Loaded'));
                } else if (state is BoardItemsTitleLoaded) {
                  // Handle BoardItemsTitleLoaded state if needed
                  return Center(child: Text('Title and ID Data Loaded'));
                } else if (state is BoardImageLoaded) {
                  // Handle BoardImageLoaded state if needed
                  return Center(child: Text('Board Image Loaded'));
                } else {
                  return Center(child: Text('Unknown state'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardList(List<BoardWithImage> boards) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: boards.length,
      itemBuilder: (context, index) {
        final board = boards[index];
        return _buildBoardCard(board);
      },
    );
  }

  Widget _buildBoardCard(BoardWithImage board) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2.0,
      child: InkWell(
        onTap: () {
          _onMaximizeIconClick(board.board);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                board.board.title ?? 'No Title',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Description: ${board.board.description ?? 'No Description'}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.memory(
                board.imageBytes,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200.0,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.open_in_full_rounded),
                    onPressed: () {
                      // Handle comment tap
                      _onMaximizeIconClick(board.board);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMaximizeIconClick(Board board) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: InsightScreen(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class BoardDetailScreen extends StatelessWidget {
  final Board board;

  BoardDetailScreen({required this.board});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Board Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Board Title: ${board.title}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'Board Description: ${board.description}',
              style: TextStyle(fontSize: 16.0),
            ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
