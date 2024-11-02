import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class NotificationWidget extends StatefulWidget {
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  bool _hasNotification = true;
  String _notificationText = "You have a new message!";

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.lightTheme.primaryColor.withOpacity(0.6),
              AppTheme.lightTheme.primaryColor.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.notifications,
              color: _hasNotification
                  ? Colors.red
                  : AppTheme.lightTheme.primaryColor,
              size: 32,
            ),
            SizedBox(width: 12),
            Expanded(
              child: _hasNotification
                  ? Text(
                _notificationText,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : Text(
                "No new notifications",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                setState(() {
                  _hasNotification = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
