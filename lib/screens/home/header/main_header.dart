import 'package:flutter/material.dart';
import 'package:myboard/screens/home/header/quick_actions.dart';
import '../../user/user_location.dart';

class MainHeaderWidget extends StatefulWidget {
  const MainHeaderWidget({Key? key}) : super(key: key);

  @override
  _MainHeaderWidgetState createState() => _MainHeaderWidgetState();
}

class _MainHeaderWidgetState extends State<MainHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 380.0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      pinned: true,
      floating: true,
      snap: true,
      /*leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white, size: 28),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),*/
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: LayoutBuilder(
          builder: (context, constraints) {
            const double maxBannerHeight = 180.0;
            const double minBannerHeight = 100.0;
            final double currentHeight = constraints.biggest.height;
            final double t = ((currentHeight - minBannerHeight) /
                (maxBannerHeight - minBannerHeight))
                .clamp(0.0, 1.0);
            final double widgetY = 20 + (t * (150 - 20));

            return Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/myboard_logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(1),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: widgetY,
                  left: 0,
                  right: 0,
                  child: Center(child: UserLocationWidget()),
                ),
              ],
            );
          },
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(210.0),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 200),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  const QuickActionsWidget(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      color: Colors.grey,
                      thickness: .0,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
