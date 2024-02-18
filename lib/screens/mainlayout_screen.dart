import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:myboard/bloc/map/map_cubit.dart';
import 'package:myboard/bloc/map/map_state.dart';
import 'package:myboard/models/location_search.dart';
import 'package:myboard/models/user.dart';
import 'package:myboard/repositories/map_repository.dart';
import 'package:myboard/repositories/user_repository.dart';
import 'package:myboard/screens/createboard_screen.dart';
import 'package:myboard/screens/createdisplay_screen.dart';
import 'package:myboard/screens/displayimage_player_screen.dart';
import 'package:myboard/screens/map_screen.dart';
import 'package:myboard/screens/menu_screen.dart';
import 'package:myboard/screens/modal-screen.dart';
import 'package:myboard/screens/viewmyboards_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  int _currentIndex = 0;
  String? _searchingWithQuery;
  late Iterable<SelectLocationDTO> _lastOptions = <SelectLocationDTO>[];
  final userRepository = GetIt.instance<UserRepository>();
  late MyBoardUser myBoardUser = MyBoardUser(id: '', username: '');
  final GetIt getIt = GetIt.instance;
  final List<Widget> _screens = [
    CreateBoardScreen(),
    CreateDisplayScreen(),
    ViewMyboardScreen(),
    MapScreen()
    // Add more screens here
  ];

  final ScrollController _scrollController = ScrollController();
  late List<int> _profilePic = [];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _initUser();
    _loadProfilePic(); // Call the method to load the profile picture
  }

  // Add a method to load the profile picture
  void _loadProfilePic() async {
    try {
      final profilePic = await userRepository.getProfilePic();
      setState(() {
        _profilePic = profilePic;
      });
    } catch (e) {
      print('Failed to load profile picture: $e');
    }
  }

  // Add this method to fetch saved location
  void _initUser() async {
    try {
      myBoardUser = await userRepository.initUser();
      // Once the user is fetched, you can setState to rebuild the UI
      setState(() {});
      print(myBoardUser);
    } catch (e) {
      print('Failed to fetch saved location: $e');
    }
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
          backgroundColor: Colors.transparent,
          // Set the background color to transparent
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.indigo[300]!,
                  Colors.indigo[500]!, // Adjust gradient colors as needed
                ],
              ),
            ),
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
            _buildLocationInfo(),
            _buildNavigationLinks(),
            _buildUserMenu(),
            _buildLogoutButton(),
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

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        _logout(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 100,
      width: 400,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Include the search bar and make it take the remaining space
          Expanded(
            child: _buildAutocomplete(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        if (state is SelectedLocation) {
          // If the map state is SelectedLocation, use the selectedLocation directly
          final location = state.selectedLocation;
          return _buildLocationWidget(location);
        } else {
          // If the map state is not SelectedLocation, fetch the user's location from userRepository
          return FutureBuilder<MyBoardUser>(
            future: userRepository.initUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the future is complete, get the user's location from the snapshot
                final location = snapshot.data?.location;
                final selectLocationDTO = location != null
                    ? SelectLocationDTO(
                        name: location.name,
                        latitude: location.latitude,
                        // Add this line with actual latitude
                        longitude: location
                            .longitude, // Add this line with actual longitude
                      )
                    : null;

                return _buildLocationWidget(selectLocationDTO);
              } else {
                // While the future is still loading, show a CircularProgressIndicator
                return CircularProgressIndicator();
              }
            },
          );
        }
      },
    );
  }

  Widget _buildLocationWidget(SelectLocationDTO? location) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on,
          color: Colors.red,
        ),
        Text(
          'Current location selected as :',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        Text(
          location != null ? location.name : 'Select a location',
          style: TextStyle(
            fontSize: 20,
            color: Colors.yellow,
          ),
        ),
      ],
    );
  }

  Widget _buildAutocomplete() {
    return Autocomplete<SelectLocationDTO>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        _searchingWithQuery = textEditingValue.text;
        Completer<Iterable<SelectLocationDTO>> completer = Completer();
        EasyDebounce.debounce(
          'searchDebounce',
          Duration(milliseconds: 500),
          () async {
            await Future.delayed(Duration.zero);
            final Iterable<SelectLocationDTO> options =
                await MapRepository().searchPlaces(_searchingWithQuery!);

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
      onSelected: (SelectLocationDTO selection) async {
        print("object");
        try {
          await userRepository.saveLocation(selection);
        } catch (e) {
          print('Failed to save location: $e');
        }

        context
            .read<MapCubit>()
            .emit(SelectedLocation(selectedLocation: selection));
      },
      displayStringForOption: (SelectLocationDTO option) {
        // Display both the icon and the location name
        return '${option.name}';
      },
    );
  }

  Widget _buildAppBarTitle() {
    return Container(
      child: Row(
        children: [
          Image.asset(
            'assets/myboard_logo_round.png',
            width: 100,
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationLinks() {
    return Row(
      children: [
        _buildSearchBar(),
        _buildSeparator(),
      ],
    );
  }

  Widget _buildSeparator() {
    return Container(
      color: Colors.white,
      height: 24, // Adjust the height as needed
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }

  void _logout(BuildContext context) async {
    try {
      // Call the logout API using the UserRepository
      final UserRepository userRepository = getIt<UserRepository>();
      await userRepository.logout();

      // Navigate to the login screen
      Navigator.pushReplacementNamed(context,
          '/login'); // Replace '/login' with the route name of your login screen
    } catch (e) {
      // Handle logout error
      print('Error logging out: $e');
    }
  }

  Widget _buildUserMenu() {
    return GestureDetector(
      onTap: () {
        ModalManager.showModal(
          context: context,
          widget: MenuScreen(// Pass the logout callback function
              ),
          headerText: '',
          heightFactor: 0.9,
          widthFactor: .3,
          isScrollControlled: true,
          backgroundColor: Colors.indigo,
          textColor: Colors.white,
        );
      },
      child: Stack(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                  radius: 24,
                  backgroundImage: MemoryImage(Uint8List.fromList(_profilePic))
                      as ImageProvider<Object>),
              SizedBox(width: 8),
              Text(
                myBoardUser.username,
                style: TextStyle(
                  color: Colors.brown,
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildBottomBar() {
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
                    _buildMapsScreenButton(),
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
      style: _currentIndex == 0 ? _selectedButtonStyle : _unselectedButtonStyle,
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
      style: _currentIndex == 1 ? _selectedButtonStyle : _unselectedButtonStyle,
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
      style: _currentIndex == 3 ? _selectedButtonStyle : _unselectedButtonStyle,
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
      style: _currentIndex == 2 ? _selectedButtonStyle : _unselectedButtonStyle,
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
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              // Use Dialog widget to create a modal covering the entire screen
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              child: DisplayImagePlayer(),
            );
          },
        );
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
    );
  }

  final _selectedButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24.0),
    ),
    padding: EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 24,
    ),
    elevation: 0,
    backgroundColor: Colors.blue, // Set selected button color to blue
  );

  final _unselectedButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24.0),
    ),
    padding: EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 24,
    ),
    elevation: 0,
    backgroundColor: Colors.yellow, // Set unselected button color to yellow
  );
}
