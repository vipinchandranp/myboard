import 'package:flutter/material.dart';
import '../../models/board/board.dart';
import '../../models/common/media_type.dart';
import '../../repository/board_repository.dart';

class ViewBoardDetailsWidget extends StatefulWidget {
  final Board board;

  ViewBoardDetailsWidget({required this.board});

  @override
  _ViewBoardDetailsWidgetState createState() => _ViewBoardDetailsWidgetState();
}

class _ViewBoardDetailsWidgetState extends State<ViewBoardDetailsWidget> {
  late Board _board;
  late BoardService _boardService;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _board = widget.board;
    _initializeService();
  }

  Future<void> _initializeService() async {
    _boardService = BoardService(context);
    await _fetchBoardDetails();
  }

  Future<void> _fetchBoardDetails() async {
    try {
      final boardDetails = await _boardService.getBoardById(_board.boardId);
      setState(() {
        _board = boardDetails!;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching board details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching board details.')),
      );
    }
  }

  Future<void> _refreshData() async {
    await _fetchBoardDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Board Details'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _board.boardName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Created on: ${_board.createdDateAndTime}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Expanded(
                child: _board.mediaFiles.isEmpty
                    ? Center(child: Text('No media files available.'))
                    : ListView.builder(
                  itemCount: _board.mediaFiles.length,
                  itemBuilder: (context, index) {
                    final mediaFile = _board.mediaFiles[index];
                    return ListTile(
                      leading: mediaFile.mediaType == MediaType.image
                          ? Image.file(mediaFile.file)
                          : Icon(Icons.video_library),
                      title: Text(mediaFile.filename),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
