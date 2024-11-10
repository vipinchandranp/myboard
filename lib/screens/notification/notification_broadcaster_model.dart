import 'package:equatable/equatable.dart';
import '../../types/notification_type.dart';

class NotificationBroadcasterModel extends Equatable {
  final String? notificationId; // Nullable ID
  final NotificationType notificationType; // Type of notification
  final bool isRead; // Indicates if the notification has been read
  final String? payload; // Additional data for the notification (optional)

  NotificationBroadcasterModel({
    this.notificationId,
    required this.notificationType,
    required this.isRead,
    this.payload,
  });

  @override
  List<Object?> get props => [notificationId, notificationType, isRead, payload];

  // Factory constructor to create a NotificationBroadcasterModel from JSON
  factory NotificationBroadcasterModel.fromJson(Map<String, dynamic> json) {
    return NotificationBroadcasterModel(
      notificationId: json.containsKey('notificationId') ? json['notificationId'] as String? : null, // Handle missing ID
      notificationType: NotificationType.values.firstWhere(
            (type) => type.toString().split('.').last == json['notificationType'],
        orElse: () => NotificationType.userMessage, // Default type if notificationType is missing or invalid
      ),
      isRead: json['read'] ?? false, // Default to false if 'read' is missing
      payload: json['payload'] as String?, // Allow payload to be nullable
    );
  }



  // Method to convert a Notification to JSON
  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'notificationType': notificationType.toString().split('.').last,
      'read': isRead, // Change 'isRead' to 'read' to match incoming JSON
      'payload': payload,
    };
  }

  @override
  String toString() {
    return 'Notification(notificationId=$notificationId, notificationType=$notificationType, isRead=$isRead, payload=$payload)';
  }
}
