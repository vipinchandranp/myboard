import 'package:flutter/material.dart';

class CustomToolbar extends StatelessWidget {
  final List<ToolbarItem> items;

  CustomToolbar({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: items[index],
          );
        },
      ),
    );
  }
}

class ToolbarItem extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;

  ToolbarItem({required this.iconData, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(iconData),
      onPressed: onPressed,
      color: Colors.blue, // Customize the button color
      iconSize: 40.0, // Customize the icon size
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Custom Toolbar Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomToolbar(
          items: List.generate(
            10,
                (index) => ToolbarItem(
              iconData: Icons.star, // Replace with your desired icons
              onPressed: () {
                // Add functionality for the button
                print('Button $index pressed.');
              },
            ),
          ),
        ),
      ),
    ),
  ));
}
