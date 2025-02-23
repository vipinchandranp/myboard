import 'package:flutter/material.dart';
import '../user/user_location.dart';

class MainHeaderWidget extends StatefulWidget {
  const MainHeaderWidget({Key? key}) : super(key: key);

  @override
  _MainHeaderWidgetState createState() => _MainHeaderWidgetState();
}

class _MainHeaderWidgetState extends State<MainHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220.0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      floating: true, // Allow the app bar to float
      snap: true, // Snap back to the top when scrolling
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.black],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Logo section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/myboard_logo_round.png',
                        height: 100,
                      ),
                    ],
                  ),
                  // User location widget
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: UserLocationWidget()), // Only UserLocationWidget
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      pinned: true,
    );
  }
}
