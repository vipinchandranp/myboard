import 'package:flutter/material.dart';
import '../notification/notification_icon.dart';
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
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade500, Colors.teal.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
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
                        height: 60,
                      ),
                    ],
                  ),
                  // User location and notification icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: UserLocationWidget()),
                      const SizedBox(width: 16.0),
                      NotificationIconWidget(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      pinned: true,
      floating: false,
    );
  }
}
