import 'package:flutter/material.dart';

// Separate widget for Rounded Button
class RoundedButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const RoundedButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12.0),
        ),
      ],
    );
  }
}

