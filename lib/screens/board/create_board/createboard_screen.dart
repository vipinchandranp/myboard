import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/screens/board/create_board/createboard_showmaps_displays_screen.dart';

class CreateBoardScreen extends StatefulWidget {
  final MyBoardUser? user;

  CreateBoardScreen({this.user});

  @override
  _CreateBoardScreenState createState() => _CreateBoardScreenState();
}

class _CreateBoardScreenState extends State<CreateBoardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  XFile? _pickedFile;
  final ImagePicker _imagePicker = ImagePicker();
  final getIt = GetIt.instance;
  BoardDisplayDetails _boardDisplayDetails = BoardDisplayDetails();

  String? _titleError;
  String? _imageError;
  bool _isBoardSaved = false;

  void _submitForm(BuildContext context) {
    setState(() {
      _titleError = null;
      _imageError = null;
    });

    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;

      List<BoardDisplayDetails> displayDetailsList = [_boardDisplayDetails];

      var board = Board(
        title: title,
        imageFile: _pickedFile,
        displayDetails: displayDetailsList,
      );

      BlocProvider.of<BoardCubit>(context).createBoard(board, context);

      setState(() {
        _isBoardSaved = true; // Set the flag to true when board is saved
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Board saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      _titleController.clear();
    } else {
      return;
    }
  }

  Future<void> _getImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedFile = pickedFile;
    });
  }

  void onDisplaySelected(Map<String, dynamic> data) {
    DateTime? date = data['date'];
    List<String>? timeSlots = data['timeSlots'];
    dynamic displayDetailsData = data['displayDetails'];

    if (date != null && timeSlots != null && displayDetailsData != null) {
      List<DisplayDetails>? displayDetailsList;

      if (displayDetailsData is List) {
        displayDetailsList = displayDetailsData.map((details) {
          return DisplayDetails.fromJson(details);
        }).toList();
      } else if (displayDetailsData is DisplayDetails) {
        displayDetailsList = [displayDetailsData];
      }

      if (displayDetailsList != null && displayDetailsList.isNotEmpty) {
        DisplayDetails displayDetails = displayDetailsList[0];

        _boardDisplayDetails = BoardDisplayDetails(
          id: displayDetails.id,
          name: displayDetails.displayName,
          dateTimeSlots: timeSlots.map((timeSlot) {
            List<String> timeParts = timeSlot.split('-');
            String startTime = timeParts[0];
            String endTime = timeParts[1];

            return DateTimeSlot(
              selectedDate: date,
              startTime: TimeOfDay(
                hour: int.parse(startTime.split(":")[0]),
                minute: int.parse(startTime.split(":")[1]),
              ),
              endTime: TimeOfDay(
                hour: int.parse(endTime.split(":")[0]),
                minute: int.parse(endTime.split(":")[1]),
              ),
            );
          }).toList(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SelectDisplayMap(
            user: widget.user,
            onDisplaySelected: onDisplaySelected,
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                child: Text('Enter board details'),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Form(
                        key: _formKey,
                        // Assign the form key to the Form widget
                        child: Container(
                          padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Select a display and upload your board',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  labelText: 'Board Name',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter board name'; // Return error message if value is empty
                                  }
                                  return null; // Return null if validation passes
                                },
                              ),
                              if (_titleError != null)
                                Text(
                                  _titleError!,
                                  style: TextStyle(color: Colors.red),
                                ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _getImage,
                                child: Text('Upload image for your Board'),
                              ),
                              if (_pickedFile != null)
                                Column(
                                  children: [
                                    SizedBox(height: 16),
                                    Image.network(
                                      _pickedFile!.path,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(height: 16),
                                    Text('Uploaded File Content:'),
                                  ],
                                ),
                              SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _pickedFile == null
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          // Validate the form
                                          _submitForm(context);
                                        }
                                      },
                                icon: Icon(Icons.save),
                                label: Text('Save Board'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(16.0),
                                  textStyle: TextStyle(fontSize: 18),
                                ),
                              ),
                              if (_pickedFile == null)
                                Text(
                                  'Please upload an image for the board before saving.',
                                  style: TextStyle(color: Colors.red),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
