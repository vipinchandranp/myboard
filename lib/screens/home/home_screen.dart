import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../service/websocket_service.dart';
import '../notification/notification_list.dart';
import '../support/chat_support.dart';
import '../tools/main_tools.dart';
import 'main_header.dart';
import 'main_footer.dart'; // Import MainFooterWidget

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
    WebSocketService().connect(); // Connect to WebSocket

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
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              MainHeaderWidget(), // Main header
              MainToolsWidget(context),
            ],
          ),
          ChatSupportWidget(), // Add the floating chat button and chatbox
        ],
      ),
      bottomNavigationBar: MainFooterWidget(), // Use MainFooterWidget here
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action for the FAB button
        },
        child: FaIcon(FontAwesomeIcons.comment), // Font Awesome icon
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
