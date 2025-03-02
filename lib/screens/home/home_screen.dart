// Home Screen with a professional design
import 'package:flutter/material.dart';
import 'package:myboard/themes/app_theme.dart';
import '../tools/main_tools.dart';
import 'header/main_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate a loading delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const MainHeaderWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMainToolsBottomSheet(context),
        child: ClipOval(
          child: Image.asset(
            'assets/myboard_logo_round.png',
            fit: BoxFit.cover,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  // Bottom sheet for tools
  void _showMainToolsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: const MainToolsWidget(),
        ),
      ),
    );
  }
}