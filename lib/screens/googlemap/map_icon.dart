import 'package:flutter/material.dart';

class MapIconWidget extends StatelessWidget {
  final String assetPath;
  final double size;

  const MapIconWidget({
    Key? key,
    required this.assetPath,
    this.size = 48.0, // Default size for the map icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white, // Optional background color for the icon
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(2, 2), // Slight shadow for elevation
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0), // Padding around the image
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
