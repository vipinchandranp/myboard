import 'package:flutter/material.dart';
import '../../api_models/user_cities_response.dart';
import '../../repository/user_repository.dart';
import '../drawer/drawer_screen.dart';
import '../board/create_board.dart';
import '../display/create_display.dart';
import '../qrscanner/qr_scanner.dart';
import '../user/user_location.dart'; // Import UserLocationWidget

class HomeScreen extends StatefulWidget {
  final BuildContext context;

  HomeScreen(BuildContext context) : context = context;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: UserLocationWidget(), // Show user location widget in AppBar
      ),
      drawer: DrawerWidget(
        onDrawerOpened: () {
          (context as Element)
              .markNeedsBuild(); // Forces a rebuild of the screen
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Additional content can be added here if needed
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateDisplayWidget(context)),
                );
              },
            ),
            SizedBox(width: 40),
            IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateBoardWidget(context)),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.qr_code_scanner),
        onPressed: () async {
          final scannedData = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QRScannerWidget(),
            ),
          );

          if (scannedData != null) {
            print('Scanned QR Code: $scannedData');
            // You can do further actions with the scanned data here
          }
        },
      ),
    );
  }
}
