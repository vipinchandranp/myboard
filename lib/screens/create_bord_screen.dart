import 'package:flutter/material.dart';

class CreateBoardScreen extends StatefulWidget {
  @override
  _CreateBoardScreenState createState() => _CreateBoardScreenState();
}

class _CreateBoardScreenState extends State<CreateBoardScreen> {
  List<Widget> _draggedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Board'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildMenuGrid(),
          ),
          Expanded(
            flex: 5,
            child: buildContainer(),
          ),
        ],
      ),
    );
  }

  Widget buildMenuGrid() {
    return GridView.count(
      crossAxisCount: 3,
      children: [
        // Add your draggable items here
        Draggable(
          child: Container(
            color: Colors.blue,
            child: Center(child: Text('Draggable 1')),
          ),
          feedback: Container(
            color: Colors.blue.withOpacity(0.5),
            child: Center(child: Text('Draggable 1')),
          ),
          childWhenDragging: Container(),
        ),
        Draggable(
          child: Container(
            color: Colors.green,
            child: Center(child: Text('Draggable 2')),
          ),
          feedback: Container(
            color: Colors.green.withOpacity(0.5),
            child: Center(child: Text('Draggable 2')),
          ),
          childWhenDragging: Container(),
        ),
        // Add more draggable items as needed
      ],
    );
  }

  Widget buildContainer() {
    return Container(
      color: Colors.grey,
      child: Stack(
        children: [
          ..._draggedItems,
        ],
      ),
    );
  }
}
