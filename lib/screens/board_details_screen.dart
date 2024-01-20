import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myboard/models/board-id-title.dart';
import 'package:myboard/repositories/board_repository.dart';

class BoardDetailsScreen extends StatefulWidget {
  final BoardIdTitle board;

  BoardDetailsScreen({required this.board});

  @override
  _BoardDetailsScreenState createState() => _BoardDetailsScreenState();
}

class _BoardDetailsScreenState extends State<BoardDetailsScreen> {
  late Future<Uint8List> _imageBytesFuture;
  final BoardRepository boardRepository = BoardRepository();
  int starRating = 0; // Initial star rating

  @override
  void initState() {
    super.initState();
    _imageBytesFuture = _loadBoardDetails();
  }

  Future<Uint8List> _loadBoardDetails() async {
    try {
      Uint8List detailsImageBytes =
          await boardRepository.getBoardImageById(widget.board.id);

      return detailsImageBytes;
    } catch (e) {
      print('Failed to fetch board details: $e');
      return Uint8List(0);
    }
  }

  @override
  void didUpdateWidget(BoardDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.board != widget.board) {
      print('Selected board changed: ${widget.board.title}');
      _imageBytesFuture = _loadBoardDetails();
    }
  }

  Widget _buildStarRating() {
    return Row(
      children: List.generate(
        5,
        (index) => IconButton(
          icon: Icon(
            index < starRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              starRating = index + 1;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Board Details'),
        automaticallyImplyLeading: false, // Disable back button
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text('Menu Option 1'),
              ),
              PopupMenuItem(
                value: 2,
                child: Text('Menu Option 2'),
              ),
            ],
            onSelected: (value) {
              // Handle menu option selection
              print('Selected menu option $value');
            },
          ),
        ],
      ),
      body: FutureBuilder<Uint8List>(
        future: _imageBytesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Uint8List imageBytes = snapshot.data ?? Uint8List(0);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  'Title: ${widget.board.title}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Display other text details here

                // Display image if available
                if (imageBytes.isNotEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Image.memory(
                        Uint8List.fromList(imageBytes),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                // Comments Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comments:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Add your comments and replies widgets here

                      // Star Rating
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: _buildStarRating(),
                      ),

                      // Add a text field for new comment
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              // Handle comment submission
                              // You can access the comment using a TextEditingController
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
