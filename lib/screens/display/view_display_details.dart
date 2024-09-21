import 'dart:io';

import 'package:flutter/material.dart';
import '../../models/common/media_type.dart';
import '../../models/display/bdisplay.dart';
import '../../repository/display_repository.dart';

class ViewDisplayDetailsWidget extends StatefulWidget {
  final BDisplay display;

  ViewDisplayDetailsWidget({required this.display});

  @override
  _ViewDisplayDetailsWidgetState createState() =>
      _ViewDisplayDetailsWidgetState();
}

class _ViewDisplayDetailsWidgetState extends State<ViewDisplayDetailsWidget> {
  late BDisplay _display;
  late DisplayService _displayService;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _display = widget.display;
    _initializeService();
  }

  Future<void> _initializeService() async {
    _displayService = DisplayService(context);
    await _fetchDisplayDetails();
  }

  Future<void> _fetchDisplayDetails() async {
    try {
      final boardDetails =
          await _displayService.getDisplayById(_display.displayId);
      setState(() {
        _display = boardDetails!;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching display details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching display details.')),
      );
    }
  }

  Future<void> _refreshData() async {
    await _fetchDisplayDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Details'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _display.displayName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Created on: ${_display.createdDateAndTime}',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: _display.mediaFiles.isEmpty
                          ? Center(child: Text('No media files available.'))
                          : ListView.builder(
                              itemCount: _display.mediaFiles.length,
                              itemBuilder: (context, index) {
                                final mediaFile = _display.mediaFiles[index];
                                return ListTile(
                                  leading:
                                      mediaFile.mediaType == MediaType.image
                                          ? Image.file(mediaFile.file)
                                          : Icon(Icons.video_library),
                                  title: Text(mediaFile.filename),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
