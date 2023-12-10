import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  Responsive({required this.mobile, required this.tablet, required this.desktop});

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
          MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          // Use desktop layout if width is more than 1200 pixels
          return desktop;
        } else if (constraints.maxWidth >= 768) {
          // Use tablet layout if width is between 768 and 1200 pixels
          return tablet;
        } else {
          // Use mobile layout if width is less than 768 pixels
          return mobile;
        }
      },
    );
  }
}
