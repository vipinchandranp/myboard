import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/repositories/board_repository.dart';
import 'package:myboard/utils/user_utils.dart';
import 'package:file_picker/file_picker.dart';

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
  final picker = ImagePicker();

  // Initialize GetIt instance
  final getIt = GetIt.instance;

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      String userId = UserUtils.getLoggedInUser(context)?.id ?? '';
      String title = _titleController.text;
      String description = _descriptionController.text;

      var board = Board(isApproved: false);
      board.userId = userId;
      board.title = title;
      board.description = description;
      board.imageFile = _pickedFile;

      // Access the BoardCubit using BlocProvider
      BlocProvider.of<BoardCubit>(context).createBoard(board, context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Board created successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      _titleController.clear();
      _descriptionController.clear();
      setState(() {});
    }
  }

  XFile? _pickedFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedFile = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardCubit(getIt<BoardRepository>()),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_pickedFile != null)
                  Column(
                    children: [
                      Image.network(
                        _pickedFile!.path,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 16),
                      Text('Uploaded File Content:'),
                    ],
                  ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _getImage,
                  child: Text('Pick an Image'),
                ),
                SizedBox(height: 16),
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
          tooltip: 'Save',
          child: Icon(Icons.save),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
