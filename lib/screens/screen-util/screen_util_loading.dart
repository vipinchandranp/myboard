import 'package:flutter/material.dart';

class LoadingHelper {
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }
}
