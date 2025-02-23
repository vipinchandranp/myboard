import 'package:flutter/material.dart';
import 'package:myboard/themes/app_theme.dart';
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
    // Simulating a delay to show shimmer effect
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              MainHeaderWidget(), // Main header
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    MainToolsWidget(context),
                  ],
                ),
              ),
              // Removed MainToolsWidget from here
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMainToolsBottomSheet(context);
        },
        child: const Icon(Icons.settings),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        elevation: 6,
      ),
    );
  }

  void _showMainToolsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Transparent for custom design
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top drag handle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Expanded(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.5, // Start with 50% height
                  minChildSize: 0.3, // Minimum height
                  maxChildSize: 0.8, // Maximum height
                  expand: false,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: MainToolsWidget(context),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
