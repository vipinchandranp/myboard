import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/user/user_cubit.dart';
import 'package:myboard/bloc/user/user_state.dart';
import 'package:myboard/screens/approvals_screen.dart';
import 'package:myboard/screens/create_board_screen.dart';
import 'package:myboard/screens/custom_dialog.dart';
import 'package:myboard/screens/custom_toolbar.dart';
import 'package:myboard/screens/desktop_main_layout.dart';
import 'package:myboard/screens/home_screen.dart';
import 'package:myboard/screens/menu_item_screen.dart';
import 'package:myboard/screens/menu_screen.dart';
import 'package:myboard/screens/other_board_screen.dart';
import 'package:myboard/screens/pin_board_screen.dart';
import 'package:myboard/screens/responsive.dart';
import 'package:myboard/utils/user_utils.dart';

class MobileLayoutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Outlook Mobile Layout'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.blue,
              child: Center(
                child: Menu(),
              ),
            ),
          ),
          SizedBox(width: 10),
          Divider(),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.green,
              child: Center(
                child: Text('Section 2'),
              ),
            ),
          ),
          Divider(),
          SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.orange,
              child: Center(
                child: Text('Section 3'),
              ),
            ),
          ),
          // Footer
          Container(
            color: Colors.grey,
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text('Footer'),
            ),
          ),
        ],
      ),
      // Toolbar
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          color: Colors.blue,
          child: Center(
            child: Text('Toolbar'),
          ),
        ),
      ),
    );
  }
}

class TabletLayoutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Outlook Tablet Layout'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.blue,
              child: Center(
                child: Menu(),
              ),
            ),
          ),
          Divider(),
          SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.green,
              child: Center(
                child: Text('Section 2'),
              ),
            ),
          ),
          Divider(),
          SizedBox(width: 10),
          Expanded(
            flex: 9,
            child: Container(
              color: Colors.orange,
              child: Center(
                child: Text('Section 3'),
              ),
            ),
          ),
        ],
      ),
      // Footer
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          color: Colors.grey,
          child: Center(
            child: Text('Footer'),
          ),
        ),
      ),
    );
  }
}


class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: MobileLayoutWidget(),
      tablet: TabletLayoutWidget(),
      desktop: DesktopLayoutWidget(),
    );
  }
}
