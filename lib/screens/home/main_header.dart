import 'package:flutter/material.dart';
import 'package:myboard/widgets/profile_pic_widget.dart';
import '../user/user_location.dart'; // Import UserLocationWidget

class MainHeaderWidget extends StatefulWidget {
  const MainHeaderWidget({Key? key}) : super(key: key);

  @override
  _MainHeaderWidgetState createState() => _MainHeaderWidgetState();
}

class _MainHeaderWidgetState extends State<MainHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent, // Background color of the app bar
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade400, Colors.teal.shade200], // Teal gradient background
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Shadow color
                    offset: Offset(0, 4), // Shadow offset
                    blurRadius: 8, // Blur radius
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0), // Reduced padding for better layout
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Centered logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Static logo without animation
                        Image.asset(
                          'assets/myboard_logo_round.png', // Change this to your logo path
                          height: 60, // Adjust height as needed
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // Space between rows
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // User location widget displayed on the left
                        Expanded(
                          child: UserLocationWidget(),
                        ),
                        // Removed the profile picture code
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Divider( // Add a line at the bottom of the header
              thickness: 2, // Thickness of the divider
              color: Colors.grey, // Color of the divider
              height: 20, // Space above and below the divider
            ),
          ],
        ),
      ),
      pinned: true,
      floating: false,
    );
  }
}
