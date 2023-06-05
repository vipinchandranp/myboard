import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String boardsTabName = 'Boards';

  List<AdItem> adItems = [];

  VideoPlayerController? _videoPlayerController;
  bool _isVideoPlaying = false;
  int _currentVideoIndex = -1;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    adItems.addAll(generateSampleItems(DateTime.now(), 6));
    adItems
        .addAll(generateSampleItems(DateTime.now().add(Duration(days: 1)), 23));

    // Initialize the video player controller
    _videoPlayerController =
        VideoPlayerController.asset(adItems[0].videoAssetPath);
    _videoPlayerController!.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _videoPlayerController!.dispose();
    super.dispose();
  }

  List<AdItem> generateSampleItems(DateTime date, int count) {
    final List<AdItem> samples = [];
    for (int i = 1; i <= count; i++) {
      samples.add(
        AdItem(
          userName: 'User $i',
          description: 'Sample Ad $i',
          rating: i % 5 + 1,
          timeSlot: date,
          status: AdStatus.Pending,
          isEnabled: true,
          videoAssetPath: 'assets/videos/samplevideo.mp4',
          isLive: false,
          isRejected: false,
        ),
      );
    }
    return samples;
  }

  void _playVideo(int index) {
    setState(() {
      _isVideoPlaying = true;
      _currentVideoIndex = index;
      _videoPlayerController!.play();
    });
  }

  void _pauseVideo() {
    setState(() {
      _isVideoPlaying = false;
      _videoPlayerController!.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset('assets/myboard_logo1.png'),
              onPressed: () {
                // Open the drawer when the menu icon is pressed
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text('My Board'),
        backgroundColor: Colors.blueGrey[800],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Create Board',
              icon: Icon(Icons.create),
            ),
            Tab(
              text: 'Map',
              icon: Icon(Icons.map),
            ),
            Tab(
              text: 'Calendar',
              icon: Icon(Icons.calendar_today),
            ),
            Tab(
              text: 'My Boards',
              icon: Icon(Icons.dashboard),
            ),
            Tab(
              text: boardsTabName,
              icon: Icon(Icons.calendar_today),
            ),
          ],
        ),
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
              // Handle button pressed
              // Add your logic here
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
                    backgroundImage: AssetImage('assets/myboard_logo1.png'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'My Board',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
      body: TabBarView(
        controller: _tabController,
        children: [
          buildCalendarTab(),
          buildAdsTab(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 56,
        color: Colors.blueGrey[800],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                // Handle play button pressed
                // Add your logic here
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

  Widget buildCalendarTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2022),
            lastDay: DateTime.utc(2025),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                boardsTabName = 'Boards on ${selectedDay.day}';
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildAdsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 4,
              childAspectRatio: 1.0,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: adItems.length,
            itemBuilder: (context, index) {
              final adItem = adItems[index];
              return GestureDetector(
                onTap: () {
                  // Handle grid item tap
                  // Add your logic here
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            adItem.userName,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          if (adItem.isLive)
                            Icon(
                              Icons.live_tv,
                              color:
                                  adItem.isRejected ? Colors.red : Colors.green,
                            ),
                          PopupMenuButton<String>(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                              PopupMenuItem(
                                value: 'approve',
                                child: Text('Approve'),
                              ),
                              PopupMenuItem(
                                value: 'reject',
                                child: Text('Reject'),
                              ),
                            ],
                            onSelected: (value) {
                              // Handle menu item selected
                              if (value == 'approve') {
                                setState(() {
                                  adItem.isLive = true;
                                  adItem.isRejected = false;
                                });
                              } else if (value == 'reject') {
                                setState(() {
                                  adItem.isLive = true;
                                  adItem.isRejected = true;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: adItem.rating.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 16,
                            itemPadding: EdgeInsets.zero,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              // Handle rating update
                              // Add your logic here
                            },
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            adItem.rating.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              // Handle like button pressed
                              // Add your logic here
                            },
                            icon: Icon(Icons.thumb_up),
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            '123', // Replace with actual like count
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(width: 8.0),
                          IconButton(
                            onPressed: () {
                              // Handle dislike button pressed
                              // Add your logic here
                            },
                            icon: Icon(Icons.thumb_down),
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            '45', // Replace with actual dislike count
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(width: 8.0),
                          IconButton(
                            onPressed: () {
                              // Handle comment button pressed
                              // Add your logic here
                            },
                            icon: Icon(Icons.comment),
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            '67', // Replace with actual comment count
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(width: 8.0),
                          IconButton(
                            onPressed: () {
                              // Handle share button pressed
                              // Add your logic here
                            },
                            icon: Icon(Icons.share),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Expanded(
                        child: Stack(
                          children: [
                            if (_currentVideoIndex == index &&
                                _videoPlayerController!.value.isInitialized)
                              AspectRatio(
                                aspectRatio:
                                    _videoPlayerController!.value.aspectRatio,
                                child: VideoPlayer(_videoPlayerController!),
                              ),
                            if (!_isVideoPlaying || _currentVideoIndex != index)
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _playVideo(index),
                                    icon: Icon(Icons.play_arrow),
                                    label: Text('Preview'),
                                  ),
                                ),
                              ),
                            if (_isVideoPlaying && _currentVideoIndex == index)
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: _pauseVideo,
                                  child: Stack(
                                    children: [
                                      VideoPlayer(_videoPlayerController!),
                                      Positioned.fill(
                                        child: Container(
                                          color: Colors.black54,
                                          child: Center(
                                            child: Icon(
                                              Icons.pause,
                                              size: 50,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: VideoProgressIndicator(
                                _videoPlayerController!,
                                allowScrubbing: true,
                                colors: VideoProgressColors(
                                  playedColor: Colors.red,
                                  bufferedColor: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AdItem {
  final String userName;
  final String description;
  final int rating;
  final DateTime timeSlot;
  final bool isEnabled;
  final AdStatus status;
  final String videoAssetPath;
  bool isLive;
  bool isRejected;

  AdItem({
    required this.userName,
    required this.description,
    required this.rating,
    required this.timeSlot,
    required this.isEnabled,
    required this.status,
    required this.videoAssetPath,
    this.isLive = false,
    this.isRejected = false,
  });
}

enum AdStatus {
  Pending,
  Accepted,
  Rejected,
}
