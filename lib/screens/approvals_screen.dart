import 'package:flutter/material.dart';

class ApprovalScreen extends StatefulWidget {
  @override
  _ApprovalScreenState createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approvals'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Adjust the number of columns as needed
        ),
        itemCount: 4, // Replace with the actual number of items
        itemBuilder: (BuildContext context, int index) {
          return ApprovalItemCard(
            title: 'Item $index',
            notificationCount: index + 1, // Replace with the actual notification count
          );
        },
      ),
    );
  }
}

class ApprovalItemCard extends StatelessWidget {
  final String title;
  final int notificationCount;

  ApprovalItemCard({required this.title, required this.notificationCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          // Handle item tap
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.dashboard, size: 32), // Replace with your desired icon
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 4),
                  notificationCount > 0
                      ? IconButton(
                    onPressed: () {
                      // Handle notification icon tap
                    },
                    icon: Stack(
                      children: [
                        Icon(Icons.notifications),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: Text(
                              '$notificationCount',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      : SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: ApprovalScreen()));
}
