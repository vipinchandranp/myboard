import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/user/user_cubit.dart';
import 'package:myboard/bloc/user/user_state.dart';
import 'package:myboard/screens/create_board_screen.dart';
import 'package:myboard/screens/other_board_screen.dart';
import 'package:myboard/screens/pin_board_screen.dart';

class DesktopLayoutWidget extends StatefulWidget {
  @override
  _DesktopLayoutWidgetState createState() => _DesktopLayoutWidgetState();
}

class _DesktopLayoutWidgetState extends State<DesktopLayoutWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  int _currentIndex = 0;

  final List<Widget> _screens = [
    CreateBoardScreen(),
    PinBoardScreen(),
    // Add more screens here
  ];

  // Dummy data for the bottom buttons
  final List<String> dummyButtonLabels =
      List.generate(20, (index) => 'Button $index');

  // Scroll controller for handling scrolling
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Container(
          child: Row(
            children: [
              Image.asset(
                'myboard_logo_round.png',
                width: 60,
                height: 60,
              ),
              SizedBox(width: 8),
              BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  if (state is UserAuthenticated) {
                    final user = state.user;
                    return Text(
                      "${user.username}'s Board",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    );
                  } else {
                    return Text(
                      'Our Board',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Container(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // Handle search button press
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              buildLink('About Us', () {
                // Handle About Us link press
              }),
              buildLink('Contact Us', () {
                // Handle Contact Us link press
              }),
              buildLink('Tutorial', () {
                // Handle Tutorial link press
              }),
              SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  // Handle account button press
                },
                icon: Icon(
                  Icons.account_circle_rounded,
                  size: 32,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 0;
                            });
                          },
                          icon: Icon(Icons.add),
                          label: Text('Create Board'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            elevation: 0,
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                          icon: Icon(Icons.list),
                          label: Text('My Boards'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _screens[_currentIndex],
      persistentFooterButtons: [
        Positioned(
          bottom: 8,
          left: 8,
          child: InkWell(
            onTap: () {
              // Handle play button press
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          color: Colors.grey[200],
          child: Text(
            '© 2023 ourboard.info. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLink(String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
