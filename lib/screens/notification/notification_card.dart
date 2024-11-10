import 'package:flutter/material.dart';
import '../../types/notification_type.dart';
import 'notification_broadcaster_model.dart'; // Import your NotificationModel

class NotificationCard extends StatelessWidget {
  final NotificationBroadcasterModel notification; // Update to use NotificationModel

  const NotificationCard({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(notification.notificationType.toString().split('.').last.toUpperCase()), // Display notification type
        subtitle: Text(notification.payload ?? 'No content available'), // Display notification content
        leading: Icon(_getIconForNotificationType(notification.notificationType)), // Icon based on notification type
        tileColor: notification.isRead ? Colors.white : Colors.grey[300], // Change color if notification is read
      ),
    );
  }

  IconData _getIconForNotificationType(NotificationType type) {
    switch (type) {
      case NotificationType.boardApproved:
        return Icons.check_circle;
      case NotificationType.boardRejected:
        return Icons.cancel;
      case NotificationType.userMessage:
        return Icons.message;
      case NotificationType.systemAlert:
        return Icons.warning;
      default:
        return Icons.info; // Default icon for unrecognized types
    }
  }
}
