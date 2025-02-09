import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../types/notification_type.dart';
import 'notification_broadcaster.dart';
import 'notification_list.dart';
import 'notification_broadcaster_model.dart';

class NotificationIconWidget extends StatefulWidget {
  const NotificationIconWidget({Key? key}) : super(key: key);

  @override
  _NotificationIconWidgetState createState() => _NotificationIconWidgetState();
}

class _NotificationIconWidgetState extends State<NotificationIconWidget>
    with SingleTickerProviderStateMixin {
  static const NotificationType _listenedNotificationType =
      NotificationType.UNREAD_NOTIFICATION_COUNT;
  int _unreadCount = 0; // Track unread notifications count
  late AnimationController _animationController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

// Reuse the singleton NotificationBroadcaster
    final broadcaster = NotificationBroadcaster();
    broadcaster.connect();

// Listen for incoming notifications
    broadcaster.notificationStream.listen((notification) {
      if (notification.notificationType == _listenedNotificationType) {
        _handleIncomingNotification(notification);
      }
    });
  }

  void _handleIncomingNotification(NotificationBroadcasterModel notification) {
// Convert payload from string to integer
    int newUnreadCount = int.tryParse(notification.payload ?? '0') ?? 0;

// Play sound only if new unread count is greater than current unread count
    if (newUnreadCount > _unreadCount) {
      _playNotificationSound();
    }

    setState(() {
// Update the unread count
      _unreadCount = newUnreadCount;
    });

// Trigger animation
    _animationController.forward().then((_) => _animationController.reverse());
  }

  void _playNotificationSound() async {
    try {
      await _audioPlayer.play(AssetSource('notification.mp3'));
    } catch (e) {
      print('Error playing notification sound: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        ScaleTransition(
          scale: _animationController.drive(
            Tween(begin: 1.0, end: 1.2)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationListWidget()),
              );
              setState(() {
                _unreadCount =
                    0; // Reset unread count when opening the notification list
              });
            },
          ),
        ),
        if (_unreadCount >
            0) // Show the badge only if there are unread notifications
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$_unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
