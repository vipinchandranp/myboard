import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/display/display_cubit.dart';
import 'package:myboard/bloc/display/display_state.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/repositories/board_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  int _currentStep = 0;
  XFile? _pickedFile;
  final ImagePicker _imagePicker = ImagePicker();

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
                    if (_currentStep < 3) {
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
                      title: Text('Provide Details'),
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
                          ? SelectDisplayMap()
                          : Container(),
                      isActive: _isDisplayStepEnabled(),
                    ),
                    Step(
                      title: Text('Schedule Board'),
                      content: Text('Schedule Settings'),
                    ),
                    Step(
                      title: Text('Publish Board'),
                      content: Text('Publish Settings'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_currentStep < 3) {
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
          tooltip: 'Continue',
          child: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}

class SelectDisplayMap extends StatefulWidget {
  @override
  _SelectDisplayMapState createState() => _SelectDisplayMapState();
}

class _SelectDisplayMapState extends State<SelectDisplayMap> {
  late DisplayCubit displayCubit;

  @override
  void initState() {
    super.initState();
    displayCubit = BlocProvider.of<DisplayCubit>(context);
    // Fetch the list of all displays when the screen is initialized
    displayCubit.getAllDisplays();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayCubit, DisplayState>(
      builder: (context, state) {
        if (state is DisplayLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is DisplayLoaded) {
          return Container(
            height: 600, // Adjust the height as needed
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0), // Set the initial map center
                zoom: 2.0, // Set the initial zoom level
              ),
              markers: _getMarkers(state.displays),
            ),
          );
        } else if (state is DisplayError) {
          return Center(
            child: Text('Error: ${state.message}'),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Set<Marker> _getMarkers(List<DisplayDetails> displays) {
    Set<Marker> markers = Set();

    for (DisplayDetails displayDetails in displays) {
      if (displayDetails.latitude != null && displayDetails.longitude != null) {
        markers.add(Marker(
          markerId: MarkerId(displayDetails.id),
          position: LatLng(displayDetails.latitude, displayDetails.longitude),
          onTap: () {
            // Handle marker tap if needed
          },
        ));
      }
    }

    return markers;
  }
}
