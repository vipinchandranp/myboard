import 'package:flutter/material.dart';

import '../screens/board/create_board.dart';
import '../screens/display/create_display.dart';

class BottomToolsWidget extends StatelessWidget {
  BottomToolsWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildRoundedButton(
            context,
            icon: Icons.add_circle,
            label: 'Create Display',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateDisplayWidget(context)),
              );
            },
          ),
          _buildRoundedButton(
            context,
            icon: Icons.add_box,
            label: 'Create Board',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateBoardWidget(context)),
              );
            },
          ),
          _buildRoundedButton(
            context,
            icon: Icons.qr_code_scanner,
            label: 'Scan To Upload',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedButton(BuildContext context,
      {required IconData icon,
        required String label,
        required VoidCallback onPressed}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: onPressed,
          child: CircleAvatar(
            radius: 28.0,
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              icon,
              size: 28.0,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12.0),
        ),
      ],
    );
  }
}
