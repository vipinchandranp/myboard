import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/utils/user_utils.dart';

class CreateBoardScreen extends StatefulWidget {
  final MyBoardUser? user; // Update the type to accept nullable MyBoardUser

  CreateBoardScreen({this.user});

  @override
  _CreateBoardScreenState createState() => _CreateBoardScreenState();
}

class _CreateBoardScreenState extends State<CreateBoardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final board = Board(
        userId: UserUtils.getLoggedInUser(context)?.id ?? '',
        title: _titleController.text,
        description: _descriptionController.text,
      );

      BlocProvider.of<BoardCubit>(context).createBoard(board, context);

      saveBoardItemToBackend(board); // Pass the Board object to the backend function

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Board created successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      _titleController.clear();
      _descriptionController.clear();
      Navigator.pop(context);
    }
  }

  // Function to save the board item to the backend
  void saveBoardItemToBackend(Board board) {
    // TODO: Implement the backend saving logic here
    // Include the board object in the API request or function call
    // to save the board item along with the user ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Board Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Board Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _submitForm(context),
        child: Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
