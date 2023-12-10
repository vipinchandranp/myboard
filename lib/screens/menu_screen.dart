import 'package:flutter/material.dart';
import 'package:myboard/utils/constants.dart';
import 'package:myboard/utils/extensions.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/brown-wooden-textured-flooring-background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              Image.asset(
                'assets/myboard_logo1.png',
                width: 120,
                height: 120,
              ).addNeumorphism(),
              SizedBox(height: kDefaultPadding),
              Row(
                children: [
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      // Add your edit functionality here
                      print('Edit button pressed');
                    },
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        Text("Create Board"),
                      ],
                    ),
                  ).addNeumorphism(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
