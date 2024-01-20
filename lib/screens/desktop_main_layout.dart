import 'dart:async';
import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:myboard/bloc/map/map_cubit.dart';
import 'package:myboard/bloc/map/map_state.dart';
import 'package:myboard/bloc/user/user_cubit.dart';
import 'package:myboard/bloc/user/user_state.dart';
import 'package:myboard/models/location_search.dart';
import 'package:myboard/repositories/display_repository.dart';
import 'package:myboard/repositories/map_repository.dart';
import 'package:myboard/screens/create_board_screen.dart';
import 'package:myboard/screens/create_display_screen.dart';
import 'package:myboard/screens/map_screen.dart';
import 'package:myboard/screens/pin_board_screen.dart';
import 'package:myboard/screens/searchbar_screen.dart';

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
  String? _searchingWithQuery;
  late Iterable<SelectLocationDTO> _lastOptions = <SelectLocationDTO>[];

  final List<Widget> _screens = [
    CreateBoardScreen(),
    CreateDisplayScreen(),
    PinBoardScreen(),
    MapScreen(),
    SelectLocationBar()
    // Add more screens here
  ];

  final ScrollController _scrollController = ScrollController();
  final _searchController = TextEditingController();

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBarTitle(), // Add the search bar here
              ],
            ),
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: false,
          actions: [
            _buildNavigationLinks(),
            _buildUserMenu(),
          ],
          bottom: _buildBottomBar(),
        ),
        body: Container(
          color: Colors.indigo[300], // Set your desired background color
          child: _screens[_currentIndex],
        ),
        persistentFooterButtons: [
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 100,
      width: 400,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on,
            color: Color(0xFF7986CB),
          ),
          Expanded(
            child: Autocomplete<SelectLocationDTO>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                _searchingWithQuery = textEditingValue.text;
                Completer<Iterable<SelectLocationDTO>> completer = Completer();
                EasyDebounce.debounce(
                  'searchDebounce',
                  Duration(milliseconds: 500),
                  () async {
                    await Future.delayed(Duration.zero);
                    final Iterable<SelectLocationDTO> options =
                        await MapRepository()
                            .searchPlaces(_searchingWithQuery!);

                    if (_searchingWithQuery != textEditingValue.text) {
                      completer.complete(_lastOptions);
                    } else {
                      _lastOptions = options;
                      completer.complete(_lastOptions);
                    }
                  },
                );

                return completer.future;
              },
              onSelected: (SelectLocationDTO selection) {
                debugPrint('You just selected ${selection.name}');
                context
                    .read<MapCubit>()
                    .emit(SelectedLocation(selectedLocation: selection));
              },
              displayStringForOption: (SelectLocationDTO option) => option.name,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildAppBarTitle() {
    return Container(
      child: Row(
        children: [
          Image.asset(
            'assets/myboard_logo_round.png',
            width: 100,
            height: 100,
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
                  color: Color(0xFF7986CB),
                ),
              );
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNavigationLinks() {
    return Row(
      children: [
        _buildSearchBar(),
        _buildSeparator(),
        _buildNavigationButton('About Us', _handleAboutUs),
        _buildSeparator(),
        _buildNavigationButton('Contact Us', _handleContactUs),
        _buildSeparator(),
        _buildNavigationButton('Tutorial', _handleTutorial),
      ],
    );
  }

  Widget _buildSeparator() {
    return Container(
      height: 24, // Adjust the height as needed
      width: 1,
      color: Colors.grey, // Adjust the color as needed
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }

  Widget _buildNavigationButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        textStyle: TextStyle(
          fontSize: 16,
          color: Color(0xFF7986CB), // Use your desired color
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        child: Text(label),
      ),
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
        padding: EdgeInsets.only(right: 50),
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
                    _buildCreateDisplayButton(),
                    SizedBox(width: 16),
                    _buildMyBoardsButton(),
                    SizedBox(width: 16),
                    _buildGoLiveButton(),
                    SizedBox(width: 16),
                    _buildMapsScreenButton(),
                    SizedBox(width: 16),
                    _buildSearchButton(),
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

  Widget _buildCreateDisplayButton() {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          _currentIndex = 1;
        });
      },
      icon: Icon(Icons.tv_rounded),
      label: Text('Create Display'),
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
      icon: Icon(Icons.map_rounded),
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
      onPressed: () => {}, // Call the backend on button press
      icon: Icon(Icons.live_tv),
      label: Text('My Live Boards'),
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
          _currentIndex = 2;
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

  Widget _buildSearchButton() {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          _currentIndex = 4;
        });
      },
      icon: Icon(Icons.location_city),
      label: Text('Select Location'),
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
