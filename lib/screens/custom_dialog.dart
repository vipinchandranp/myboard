import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class MyBoardDialog {
  final String message;
  final DialogType dialogType;

  MyBoardDialog({
    required this.message,
    required this.dialogType,
  });

  void showDialogBox(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.scale,
      desc: message,
      btnOkOnPress: () {
        Navigator.popUntil(context, ModalRoute.withName('/main'));
      },
    ).show();
  }
}
