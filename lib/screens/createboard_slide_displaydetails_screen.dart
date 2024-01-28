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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // Adjust the duration as needed
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        double screenWidth = MediaQuery.of(context).size.width;
        double offset = 0;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          // You can add additional logic to close the sheet when tapped
          _animationController.reverse();
          Navigator.pop(context);
        },
        child: Material(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
