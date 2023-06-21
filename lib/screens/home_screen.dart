import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/board/board_cubit.dart';
import 'package:myboard/bloc/board/board_state.dart';
import 'package:myboard/bloc/user/user_cubit.dart';
import 'package:myboard/bloc/user/user_state.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/screens/create_board_screen.dart';
import 'package:myboard/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/user/user_cubit.dart';
import 'package:myboard/bloc/user/user_state.dart';
import 'package:myboard/screens/notification_screen.dart';
import 'package:myboard/screens/pin_board_screen.dart';
import 'package:myboard/screens/play_live_screen.dart';
import 'package:myboard/utils/user_utils.dart';
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset('assets/myboard_logo1.png'),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserAuthenticated) {
              final user = state.user;
              return Text(
                "${user.username}'s board",
                style: TextStyle(fontSize: 18),
              );
            } else {
              return Text(
                'My Board',
                style: TextStyle(fontSize: 18),
              );
            }
          },
        ),
        backgroundColor: Colors.blueGrey[800],
        actions: [
          IconButton(
            onPressed: () {
              // Handle button pressed
              // Add your logic here
            },
            icon: Icon(Icons.shopping_cart, color: Colors.teal),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
            icon: Icon(Icons.notifications, color: Colors.teal),
          ),
          IconButton(
            onPressed: () {
              // Handle button pressed
              // Add your logic here
            },
            icon: Icon(Icons.settings, color: Colors.teal),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile_image.jpg'),
                  ),
                  SizedBox(height: 8),
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      if (state is UserAuthenticated) {
                        final user = state.user;
                        return Text(
                          user.username,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Handle drawer item tap
                // Add your logic here
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                // Handle drawer item tap
                // Add your logic here
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle drawer item tap
                // Add your logic here
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle drawer item tap
                // Add your logic here
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<BoardCubit, BoardState>(
        builder: (context, state) {
          if (state is BoardLoaded) {
            final List<Board> boards = state.boards;
            return PinBoardScreen();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateBoardScreen(user: UserUtils.getLoggedInUser(context) )),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 56,
        color: Colors.blueGrey[800],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayLiveScreen(),
                  ),
                );
              },
              icon: Icon(Icons.play_arrow, color: Colors.white),
            ),
            Text(
              'MyBoards 2023',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
