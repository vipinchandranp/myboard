import 'package:flutter/material.dart';

class PulsatingMarker extends StatefulWidget {
  final double latitude;
  final double longitude;
  final VoidCallback onTap;

  PulsatingMarker({
    required this.latitude,
    required this.longitude,
    required this.onTap,
  });

  @override
  _PulsatingMarkerState createState() => _PulsatingMarkerState();
}

class _PulsatingMarkerState extends State<PulsatingMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: widget.latitude,
          left: widget.longitude,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Transform.scale(
              scale: 1 + (_controller.value * 0.5), // Pulsating effect
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.5),
                ),
                child: Center(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
