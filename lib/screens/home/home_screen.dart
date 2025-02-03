import 'package:flutter/material.dart';
import '../tools/main_tools.dart';
import 'main_header.dart';

class HomeScreen extends StatefulWidget {
  final BuildContext context;

  HomeScreen(this.context); // Keep context as is

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true; // Simulating loading state

  @override
  void initState() {
    super.initState();
    // WebSocketService().connect(); // Connect to WebSocket

    // Simulating a delay to show shimmer effect
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              MainHeaderWidget(), // Main header

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Removed EnterDisplayPinWidget
                  ],
                ),
              ),
              MainToolsWidget(context), // Main tools
            ],
          ),
        ],
      )
    );
  }
}