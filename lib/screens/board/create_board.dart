import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../models/board/board_media_file.dart';
import '../../models/common/media_file.dart';
import '../../models/common/media_type.dart';
import '../../repository/board_repository.dart';
import 'package:animate_do/animate_do.dart';

class CreateBoardWidget extends StatefulWidget {
  final BuildContext context;

  CreateBoardWidget(this.context);

  @override
  _CreateBoardWidgetState createState() => _CreateBoardWidgetState();
}

class _CreateBoardWidgetState extends State<CreateBoardWidget> {
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _boardNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<BoardMediaFile> _mediaFiles = [];
  List<VideoPlayerController> _videoControllers = [];
  bool _isUploading = false;
  String _boardName = "";

  late BoardService _boardService;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    _boardService = BoardService(widget.context);
  }

  Future<void> _pickMedia() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _uploadMedia(File(pickedFile.path), MediaType.image);
    } else {
      final pickedVideo = await _picker.pickVideo(source: ImageSource.gallery);
      if (pickedVideo != null) {
        final videoController =
        VideoPlayerController.file(File(pickedVideo.path));
        await videoController.initialize();
        await _uploadMedia(File(pickedVideo.path), MediaType.video);
        setState(() {
          _videoControllers.add(videoController);
        });
      }
    }
  }

  Future<void> _uploadMedia(File file, MediaType mediaType) async {
    setState(() {
      _isUploading = true;
    });

    try {
      final data = await _boardService.saveBoard(file, _boardName);

      if (data != null) {
        setState(() {
          _mediaFiles.add(
            BoardMediaFile(
              file: file,
              boardId: data['boardId'],
              filename: data['fileName'],
              mediaType: mediaType,
            ),
          );
        });

        _scrollToBottom();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload media. Please try again.')),
        );
      }
    } catch (e) {
      print('Error uploading media: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading media. Please try again.')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _removeMedia(int index) async {
    final mediaFile = _mediaFiles[index];

    try {
      final success = await _boardService.deleteBoardFile(
          mediaFile.boardId, mediaFile.filename);

      if (success) {
        setState(() {
          if (mediaFile.mediaType == MediaType.video) {
            _videoControllers[index].dispose();
            _videoControllers.removeAt(index);
          }
          _mediaFiles.removeAt(index);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove media.')),
        );
      }
    } catch (e) {
      print('Error removing media: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing media. Please try again.')),
      );
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _boardNameController.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Board'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _boardNameController,
                decoration: InputDecoration(
                  labelText: 'Board Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a board name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _boardName = value;
                  });
                },
              ),
              SizedBox(height: 16),
              if (_mediaFiles.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _mediaFiles.length,
                    itemBuilder: (context, index) {
                      final mediaFile = _mediaFiles[index];
                      return FadeInUp(
                        duration: Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6.0,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: _buildMediaWidget(mediaFile, index),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Tooltip(
                                  message: 'Delete',
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.white),
                                      onPressed: () => _removeMedia(index),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                Center(
                  child: Text(
                    'No media uploaded yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              SizedBox(height: 10),
              Center(
                child: _isUploading
                    ? CircularProgressIndicator()
                    : FloatingActionButton(
                  onPressed: _pickMedia,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.add, size: 30),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaWidget(MediaFile mediaFile, int index) {
    switch (mediaFile.mediaType) {
      case MediaType.image:
        return Image.file(
          mediaFile.file,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        );
      case MediaType.video:
        return AspectRatio(
          aspectRatio: _videoControllers[index].value.aspectRatio,
          child: VideoPlayer(_videoControllers[index]),
        );
      default:
        return Container();
    }
  }
}
