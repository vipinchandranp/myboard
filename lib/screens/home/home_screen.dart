import 'package:flutter/material.dart';
import '../../widgets/bottom_tools_widget.dart';
import '../drawer/drawer_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search functionality
            },
          ),
        ],
      ),
      drawer: DrawerWidget(
        onDrawerOpened: () {
          // Trigger a refresh or any action when the drawer is opened
          (context as Element)
              .markNeedsBuild(); // This forces a rebuild of the screen
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: IconButton(
          icon: Icon(Icons.add_circle_outline,
              color: Theme.of(context).primaryColor),
          onPressed: () {
            _showBottomSheet(context);
          },
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return BottomToolsWidget(context);
      },
    );
  }
}
