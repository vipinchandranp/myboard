import 'package:flutter/material.dart';
import 'package:myboard/screens/home/home_screen.dart';
import '../../models/display/bdisplay.dart';
import '../../repository/display_repository.dart';
import 'display_card.dart';

class ViewDisplayWidget extends StatefulWidget {
  @override
  _ViewDisplaysWidgetState createState() => _ViewDisplaysWidgetState();
}

class _ViewDisplaysWidgetState extends State<ViewDisplayWidget> {
  List<BDisplay> _displays = [];
  bool _isLoading = true;

  late DisplayService _displayService;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    _displayService = DisplayService(context);
    await _fetchDisplays();
  }

  Future<void> _fetchDisplays() async {
    try {
      final displays = await _displayService.getDisplays();
      setState(() {
        _displays = displays ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching displays: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Displays'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _displays.isEmpty
              ? const Center(child: Text('No displays found.'))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _displays.length,
                      itemBuilder: (context, index) {
                        final display = _displays[index];
                        return GestureDetector(
                          child: DisplayCardWidget(
                              display:
                                  display), // Use the new DisplayCardWidget
                        );
                      },
                    );
                  },
                ),
    );
  }
}
