import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/repositories/board_repository.dart';
import 'package:myboard/screens/createboard_showmaps_displays_screen.dart';

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
  int _currentStep = 0;
  XFile? _pickedFile;
  final ImagePicker _imagePicker = ImagePicker();
  final getIt = GetIt.instance;
  BoardDisplayDetails _boardDisplayDetails = BoardDisplayDetails();

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;
      String description = _descriptionController.text;

      // Create a list and add boardDisplayDetails to it
      List<BoardDisplayDetails> displayDetailsList = [_boardDisplayDetails];

      var board = Board(
        title: title,
        description: description,
        imageFile: _pickedFile,
        displayDetails: displayDetailsList,
      );

      // Access the BoardCubit using BlocProvider
      BlocProvider.of<BoardCubit>(context).createBoard(board, context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Board saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      _titleController.clear();
      _descriptionController.clear();
    }
  }

  Future<void> _getImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedFile = pickedFile;
    });
  }

  bool _isDisplayStepEnabled() {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty;
  }

  void onDisplaySelected(Map<String, dynamic> data) {
    DateTime? date = data['date'];
    List<String>? timeSlots =  data['timeSlots'];
    dynamic displayDetailsData = data['displayDetails'];

    if (date != null && timeSlots != null && displayDetailsData != null) {
      List<DisplayDetails>? displayDetailsList;

      if (displayDetailsData is List) {
        // Check if the received displayDetailsData is a List
        displayDetailsList = displayDetailsData.cast<DisplayDetails>();
      } else if (displayDetailsData is DisplayDetails) {
        // If it's a single DisplayDetails instance, convert it to a list
        displayDetailsList = [displayDetailsData];
      }

      if (displayDetailsList != null && displayDetailsList.isNotEmpty) {
        // Assuming displayDetailsList is a list, for demonstration purposes, taking the first item
        // Create a new instance of BoardDisplayDetails
        BoardDisplayDetails displayDetails = BoardDisplayDetails(
          dateTimeSlots: timeSlots.map((timeSlot) {
            // Replace the placeholder values with your actual logic to convert timeSlot string
            // into DateTime or TimeOfDay and create a new DateTimeSlot instance
            return DateTimeSlot(
              // Replace with your actual logic to parse and convert timeSlot to DateTime
              selectedDate: date,
              // Replace with your actual logic to parse and convert timeSlot to TimeOfDay
              startTime: TimeOfDay(hour: 0, minute: 0),
              endTime: TimeOfDay(hour: 0, minute: 0),
            );
          }).toList(),
        );

        // Create a new instance of BoardDisplayDetails with updated values
        _boardDisplayDetails = BoardDisplayDetails(
          name: displayDetails.name, // You may need to provide the actual name
          dateTimeSlots: displayDetails.dateTimeSlots,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardCubit(getIt<BoardRepository>()),
      child: Scaffold(
          body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stepper(
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep < 1) {
                    if (_currentStep == 0 && !_isDisplayStepEnabled()) {
                      // If on the first step and the display step is not enabled, don't proceed
                      return;
                    }
                    setState(() {
                      _currentStep += 1;
                    });
                  } else {
                    _submitForm(context);
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep -= 1;
                    });
                  } else {
                    // Handle cancel if needed
                  }
                },
                steps: [
                  Step(
                    title: Text('Board Details'),
                    content: Form(
                      key: _formKey,
                      child: Container(
                        width: 300, // Set your desired width
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
                            Container(
                              width: 200,
                              // Set your desired width for the button
                              height: 40,
                              // Set your desired height for the button
                              child: ElevatedButton(
                                onPressed: _getImage,
                                child: Text('Pick an Image'),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _titleController,
                              decoration:
                                  InputDecoration(labelText: 'Board Title'),
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
                              decoration: InputDecoration(
                                  labelText: 'Board Description'),
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
                  ),
                  Step(
                    title: Text('Select Display'),
                    content: _isDisplayStepEnabled()
                        ? SelectDisplayMap(
                            user: widget.user,
                            onDisplaySelected:
                                onDisplaySelected, // Pass the callback function
                          )
                        : Container(),
                    isActive: _isDisplayStepEnabled(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                // Align buttons to the left
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      _submitForm(context);
                    },
                    tooltip: 'Publish',
                    child: Icon(Icons.publish),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
