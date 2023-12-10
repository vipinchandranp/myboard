import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:myboard/utils/extensions.dart';

class OtherBoardScreen extends StatefulWidget {
  final String userName;
  final String userDetails;
  String? userProfileImageUrl;
  final int starValue;

  OtherBoardScreen({
    required this.userName,
    required this.userDetails,
    this.userProfileImageUrl,
    required this.starValue,
  });

  @override
  _OtherBoardScreenState createState() => _OtherBoardScreenState();
}

class _OtherBoardScreenState extends State<OtherBoardScreen> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.userProfileImageUrl ?? ""),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(widget.userDetails),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    // Handle menu item tap
                    print('Menu item tapped');
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  widget.userProfileImageUrl ?? "" ,
                  height: 800,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildStarButtons(), // Add the star buttons
                IconButton(
                  onPressed: () {
                    // Handle like button tap
                    setState(() {
                      isLiked = !isLiked;
                    });
                    print('Like button tapped');
                  },
                  icon: Icon(
                    isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                    color: isLiked ? Colors.blue : null,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Handle dislike button tap
                    print('Dislike button tapped');
                  },
                  icon: Icon(Icons.thumb_down),
                ),
                IconButton(
                  onPressed: () {
                    // Handle comments button tap
                    print('Comments button tapped');
                    _showComments(context); // Show comments modal bottom sheet
                  },
                  icon: Icon(Icons.comment),
                ),
                IconButton(
                  onPressed: () {
                    // Handle share button tap
                    print('Share button tapped');
                  },
                  icon: Icon(Icons.share),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarButtons() {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++)
          IconButton(
            onPressed: () {
              // Handle star button tap
              print('Star button $i tapped');
            },
            icon: Icon(Icons.star),
            color: i <= widget.starValue ? Colors.amber : Colors.grey,
          ),
      ],
    );
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                  thickness: 3,
                  indent: 30,
                  color: Color(0xFF7986CB)
              ),
              Text(
                'Comments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              _buildCommentItem('User1', 'Great post!'),
              Divider(),
              _buildCommentItem('User2', 'Awesome!'),
              Divider(),
              _buildCommentItem('User3', 'Nice work!'),
              Divider(),
              // Add more comments here
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentItem(String user, String comment) {
    bool isLiked = false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.userProfileImageUrl ?? ""),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(comment),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  // Handle reply button tap
                  _showReplyDialog(context, user); // Show reply dialog
                },
                child: Text('Reply'),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Handle like button tap
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    icon: Icon(
                      isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                      color: isLiked ? Colors.blue : null,
                    ),
                  ),
                  Text('0'), // You can show the number of likes here
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReplyDialog(BuildContext context, String user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reply to $user'),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'Enter your comment...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle cancel button tap
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle reply button tap
                // Add your logic to save the reply comment here
                Navigator.pop(context);
              },
              child: Text('Reply'),
            ),
          ],
        );
      },
    );
  }
}

class VerticalCardList extends StatefulWidget {
  @override
  _VerticalCardListState createState() => _VerticalCardListState();
}

class _VerticalCardListState extends State<VerticalCardList> {
  PageController _pageController = PageController();
  CarouselController _carouselController = CarouselController();
  List<OtherBoardScreen> _cards = [
    OtherBoardScreen(
      userName: 'John Doe',
      userDetails: 'Software Engineer',
     // userProfileImageUrl: 'assets/myboard_logo1.png',
      starValue: 3,
    ),
    OtherBoardScreen(
      userName: 'Jane Smith',
      userDetails: 'Product Designer',
     // userProfileImageUrl: 'assets/myboard_logo1.png',
      starValue: 3,
    ),
    OtherBoardScreen(
      userName: 'Alice Johnson',
      userDetails: 'Frontend Developer',
    //  userProfileImageUrl: 'assets/myboard_logo1.png',
      starValue: 5,
    ),
    // Add more cards here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider.builder(
        carouselController: _carouselController,
        itemCount: _cards.length,
        itemBuilder: (context, index, realIndex) {
          return _cards[index];
        },
        options: CarouselOptions(
          aspectRatio: 2.5,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
          autoPlay: false, // Set to true for automatic carousel sliding
          // Add any other carousel options you want here
        ),
      )
    );
  }
}
