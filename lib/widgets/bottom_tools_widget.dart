import 'package:flutter/material.dart';
import 'package:myboard/widgets/round_button.dart';

class BottomToolsWidget extends StatelessWidget {
  final List<RoundedButton> buttons;

  BottomToolsWidget({required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons,  // Render the buttons passed in
      ),
    );
  }
}
