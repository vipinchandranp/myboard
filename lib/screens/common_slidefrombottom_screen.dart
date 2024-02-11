import 'package:flutter/material.dart';

class CustomSlideSheet extends StatefulWidget {
  final Widget child;

  CustomSlideSheet({required this.child});

  @override
  _CustomSlideSheetState createState() => _CustomSlideSheetState();
}

class _CustomSlideSheetState extends State<CustomSlideSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // Adjust the duration as needed
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Offsets the sheet downwards
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _offsetAnimation,
          child: child,
        );
      },
      child: Material(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20), // Adds rounded corners at the top
          ),
        ),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
