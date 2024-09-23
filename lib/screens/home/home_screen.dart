import 'package:flutter/material.dart';
import '../../widgets/bottom_tools_widget.dart';
import '../../widgets/round_button.dart';
import '../drawer/drawer_screen.dart';
import '../board/create_board.dart';
import '../display/create_display.dart';

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
          children: <Widget>[],
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
        // Pass the list of buttons to BottomToolsWidget
        return BottomToolsWidget(
          buttons: [
            RoundedButton(
              icon: Icons.add_circle,
              label: 'Create Display',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateDisplayWidget(context)),
                );
              },
            ),
            RoundedButton(
              icon: Icons.add_box,
              label: 'Create Board',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateBoardWidget(context)),
                );
              },
            ),
            RoundedButton(
              icon: Icons.qr_code_scanner,
              label: 'Scan To Upload',
              onPressed: () {
                // Handle scan upload functionality
              },
            ),
          ],
        );
      },
    );
  }
}
