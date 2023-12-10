import 'package:flutter/material.dart';

class LoadingHelper {
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: LoadingWidget(),
        ),
      ),
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class LoadingWidget extends StatefulWidget {
  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset('myboard_logo_round.png', width: 100, height: 100),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
