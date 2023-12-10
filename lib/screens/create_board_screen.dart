import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/utils/user_utils.dart';

class CreateBoardScreen extends StatefulWidget {
  final MyBoardUser? user;

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
      String userId = UserUtils.getLoggedInUser(context)?.id ?? '';
      String title = _titleController.text;
      String description = _descriptionController.text;

      var board = Board();
      board.userId = userId;
      board.title = title;
      board.description = description;

      BlocProvider.of<BoardCubit>(context).createBoard(board, context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Board created successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      _titleController.clear();
      _descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
