import 'package:flutter/material.dart';
import 'package:myboard/widgets/profile_pic_widget.dart';
import '../../themes/app_theme.dart';

class MBUserProfile extends StatelessWidget {
  final bool editable;

  const MBUserProfile({Key? key, this.editable = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 16),
            ProfilePictureWidget(isEditable: true,)
          ],
        ),
        SizedBox(height: 5), // Space between elements
        // You can add more profile details here
      ],
    );
  }
}
