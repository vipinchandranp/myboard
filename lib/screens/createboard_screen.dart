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
  XFile? _pickedFile;
  final ImagePicker _imagePicker = ImagePicker();
  final getIt = GetIt.instance;
  BoardDisplayDetails _boardDisplayDetails = BoardDisplayDetails();

  String? _titleError;
  String? _descriptionError;
  String? _imageError;

  void _submitForm(BuildContext context) {
    setState(() {
      _titleError = null;
      _descriptionError = null;
      _imageError = null;
    });

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
    } else {
      // Validation failed, return without saving
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
        // Check if the received displayDetailsData is a List
        displayDetailsList = displayDetailsData.map((details) {
          return DisplayDetails.fromJson(details);
        }).toList();
      } else if (displayDetailsData is DisplayDetails) {
        // If it's a single DisplayDetails instance, convert it to a list
        displayDetailsList = [displayDetailsData];
      }

      if (displayDetailsList != null && displayDetailsList.isNotEmpty) {
        // Assuming displayDetailsList is a list, for demonstration purposes, taking the first item
        DisplayDetails displayDetails =
            displayDetailsList[0]; // Taking the first item

        // Create a new instance of BoardDisplayDetails
        _boardDisplayDetails = BoardDisplayDetails(
          id: displayDetails.id,
          // Assuming displayDetails has an id property
          name: displayDetails.displayName,
          // You may need to provide the actual name
          dateTimeSlots: timeSlots.map((timeSlot) {
            // Split the timeSlot string into hours and minutes
            List<String> timeParts = timeSlot.split(':');
            int startHour = int.parse(timeParts[0]);
            int startMinute = int.parse(timeParts[1]);

            // Calculate the end time (assuming one hour duration)
            int endHour = startHour + 1;
            int endMinute = startMinute;

            // Create a new DateTimeSlot instance
            return DateTimeSlot(
              selectedDate: date,
              startTime: TimeOfDay(hour: startHour, minute: startMinute),
              endTime: TimeOfDay(hour: endHour, minute: endMinute),
            );
          }).toList(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(labelText: 'Board Name'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                _titleError = 'Please enter a title.';
                              });
                              return null;
                            }
                            return null;
                          },
                        ),
                        if (_titleError != null)
                          Text(
                            _titleError!,
                            style: TextStyle(color: Colors.red),
                          ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          decoration:
                              InputDecoration(labelText: 'Board Description'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                _descriptionError =
                                    'Please enter a description.';
                              });
                              return null;
                            }
                            return null;
                          },
                          maxLines:
                              20, // Increase the height of the description
                        ),
                        if (_descriptionError != null)
                          Text(
                            _descriptionError!,
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
                          onPressed: () {
                            _submitForm(context);
                          },
                          icon: Icon(Icons.save),
                          label: Text('Save Board'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(16.0),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: SelectDisplayMap(
              user: widget.user,
              onDisplaySelected: onDisplaySelected,
            ),
          ),
        ],
      ),
    );
  }
}
