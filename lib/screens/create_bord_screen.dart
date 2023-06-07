import 'package:flutter/material.dart';

class BoardItem {
  final String text;
  final Color color;

  BoardItem({
    required this.text,
    required this.color,
  });
}

class CreateBoardScreen extends StatefulWidget {
  @override
  _CreateBoardScreenState createState() => _CreateBoardScreenState();
}

class _CreateBoardScreenState extends State<CreateBoardScreen> {
  TextEditingController _textEditingController = TextEditingController();
  List<BoardItem> _boardItems = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Board'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _boardItems.length,
              itemBuilder: (context, index) {
                final boardItem = _boardItems[index];
                return ListTile(
                  title: Text(boardItem.text),
                  tileColor: boardItem.color,
                );
              },
            ),
          ),
          TextField(
            maxLines: null,
            controller: _textEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter the text here...',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle saving the content
          _saveContent();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  void _saveContent() {
    final String text = _textEditingController.text;
    final BoardItem boardItem = BoardItem(
      text: text,
      color: Colors.yellow, // You can customize the color here
    );
    setState(() {
      _boardItems.add(boardItem);
      _textEditingController.clear();
    });
  }
}
