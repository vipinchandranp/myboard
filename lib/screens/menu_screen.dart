import 'package:flutter/material.dart';
import 'package:myboard/screens/modal-screen.dart';
import 'package:myboard/screens/profile_screen.dart';

class MenuScreen extends StatelessWidget {

  final List<Map<String, dynamic>> buttonData = [
    {'icon': Icons.settings, 'text': 'Settings'},
    {'icon': Icons.account_circle, 'text': 'Profile'},
    {'icon': Icons.payment, 'text': 'Payment'},
    {'icon': Icons.school, 'text': 'Tutorial'},
    {'icon': Icons.info, 'text': 'About Us'},
    {'icon': Icons.contact_phone, 'text': 'Contact Us'},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      padding: EdgeInsets.all(16.0),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: List.generate(buttonData.length, (index) {
        return CircularIconButton(
          icon: buttonData[index]['icon'],
          text: buttonData[index]['text'],
          onPressed: () {
            print('Pressed icon: ${buttonData[index]['text']}');
            if (buttonData[index]['text'] == 'Profile') {
              // Open ProfileScreen
              ModalManager.showModal(
                context: context,
                widget: ProfileScreen(),
                headerText: 'Profile',
                widthFactor: .3
              );
            }
          },
        );
      }),
    );
  }
}

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  CircularIconButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 36.0,
            color: Colors.blue,
          ),
          SizedBox(height: 8.0),
          Text(
            text,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}