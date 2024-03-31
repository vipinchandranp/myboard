import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/models/board_with_image.dart';
import 'package:myboard/screens/Insights/main_insight_screen.dart';

class BoardDetailScreen extends StatelessWidget {
  final Board board;

  BoardDetailScreen({required this.board});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Board Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Board Title: ${board.title}'),
            Text('Board Description: ${board.description}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}

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
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search by Date Range',
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search by Specific Date',
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Row(
                    children: [
                      Text('Toggle Approved/Unapproved Boards'),
                      Switch(
                        value: false,
                        // Example value, you need to handle its state
                        onChanged: (value) {
                          // Handle toggle state change
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle apply button press
                  },
                  child: Text('Apply'),
                ),
              ],
            ),
          ),
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
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
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
      shape: RoundedRectangleBorder(),
      child: InkWell(
        onTap: () {
          _onMaximizeIconClick(board.board);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Title and Buttons
            Container(
              decoration: BoxDecoration(
                color: Colors.white24,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      board.board.title ?? 'No Title',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.black),
                      onPressed: () {
                        // Handle options menu tap
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Main Content and Footer
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Content
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description: ${board.board.description ?? 'No Description'}',
                          style: TextStyle(
                            color: Colors.grey,
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
                      ],
                    ),
                  ),
                  // Footer with Actions
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.open_in_full_rounded,
                                color: Colors.indigo),
                            onPressed: () {
                              // Handle comment tap
                              _onMaximizeIconClick(board.board);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
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
