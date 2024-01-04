import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/user/user_cubit.dart';
import 'package:myboard/bloc/user/user_state.dart';
import 'package:myboard/models/board.dart';
import 'package:myboard/models/display_details.dart';
import 'package:myboard/screens/create_board_screen.dart';
import 'package:myboard/screens/map_screen.dart';
import 'package:myboard/screens/pin_board_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Board App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DesktopLayoutWidget(),
    );
  }
}

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
    MapScreen(),
    MapScreen()
    // Add more screens here
  ];

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
        title: _buildAppBarTitle(),
        actions: [
          _buildSearchBar(),
          _buildNavigationLinks(),
          _buildUserMenu(),
        ],
        bottom: _buildBottomBar(),
      ),
      body: _screens[_currentIndex],
      persistentFooterButtons: [
        _buildFooter(),
      ],
    );
  }

  Container _buildAppBarTitle() {
    return Container(
      child: Row(
        children: [
          Image.asset(
            'assets/myboard_logo_round.png',
            width: 60,
            height: 60,
          ),
          SizedBox(width: 8),
          BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              final isUserAuthenticated = state is UserAuthenticated;
              final username = isUserAuthenticated
                  ? (state as UserAuthenticated).user.username
                  : 'Our Board';

              return Text(
                "$username's Board",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              );
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 200,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: _handleSearch,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationLinks() {
    return Row(
      children: [
        buildLink('About Us', _handleAboutUs),
        buildLink('Contact Us', _handleContactUs),
        buildLink('Tutorial', _handleTutorial),
      ],
    );
  }

  Widget _buildUserMenu() {
    return PopupMenuButton<String>(
      onSelected: _handleMenuSelection,
      itemBuilder: (BuildContext context) {
        return {'Profile', 'Settings', 'Logout'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Row(
              children: [
                _getMenuIcon(choice),
                SizedBox(width: 8),
                Text(
                  choice,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  PreferredSize _buildBottomBar() {
    return PreferredSize(
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
                    _buildCreateBoardButton(),
                    SizedBox(width: 16),
                    _buildMyBoardsButton(),
                    SizedBox(width: 16),
                    _buildGoLiveButton(),
                    SizedBox(width: 16),
                    _buildMapsScreenButton()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateBoardButton() {
    return ElevatedButton.icon(
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
    );
  }

  Widget _buildMapsScreenButton() {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          _currentIndex = 3;
        });
      },
      icon: Icon(Icons.add),
      label: Text('Explore displays'),
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
    );
  }

  Widget _buildGoLiveButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Sample Board items
        List<Board> sampleBoardItems = [
        ];

      },
      icon: Icon(Icons.live_tv),
      label: Text('Go Live Boards'),
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
    );
  }

  Widget _buildMyBoardsButton() {
    return ElevatedButton.icon(
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
    );
  }

  Widget _buildFooter() {
    return Container(
      height: 60,
      child: Column(
        children: [_buildPlayButton()],
      ),
    );
  }

  Widget _buildPlayButton() {
    return Container(
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
            color: Color(0xFF7986CB),
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  void _handleSearch() {
    // Handle search button press
  }

  void _handleAboutUs() {
    // Handle About Us link press
  }

  void _handleContactUs() {
    // Handle Contact Us link press
  }

  void _handleTutorial() {
    // Handle Tutorial link press
  }

  void _handleMenuSelection(String choice) {
    // Handle menu item selection here
    switch (choice) {
      case 'Profile':
        // Implement profile handling
        break;
      case 'Settings':
        // Implement settings handling
        break;
      case 'Logout':
        // Implement logout handling
        break;
    }
  }

  Widget _getMenuIcon(String choice) {
    switch (choice) {
      case 'Profile':
        return Icon(Icons.person, color: Colors.black);
      case 'Settings':
        return Icon(Icons.settings, color: Colors.black);
      case 'Logout':
        return Icon(Icons.exit_to_app, color: Colors.black);
      default:
        return Icon(Icons.more_vert, color: Colors.black);
    }
  }
}
