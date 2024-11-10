import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';  // Import shimmer package
import 'package:myboard/screens/notification/notification_card.dart';
import '../../repository/notification_repository.dart';
import 'notification_broadcaster_model.dart';

class NotificationListWidget extends StatefulWidget {
  const NotificationListWidget({Key? key}) : super(key: key);

  @override
  _NotificationListWidgetState createState() =>
      _NotificationListWidgetState();
}

class _NotificationListWidgetState extends State<NotificationListWidget> {
  final List<NotificationBroadcasterModel> _notifications = [];
  final int _pageSize = 10; // Number of notifications per page
  int _currentPage = 0; // Current page for pagination
  bool _isLoading = false; // Indicates if notifications are being loaded
  bool _hasMoreNotifications = true; // Indicates if there are more notifications
  late ScrollController _scrollController; // Controller for detecting scroll position

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _fetchNotifications(); // Fetch notifications on initialization
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  /// Fetch notifications from the API with pagination.
  Future<void> _fetchNotifications() async {
    if (_isLoading || !_hasMoreNotifications) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch notifications using the NotificationService
      final response = await NotificationService(context).fetchAllNotifications(
        _currentPage, // Pass current page
        _pageSize,    // Pass page size
      );

      setState(() {
        final fetchedNotifications = response.data ?? [];

        // If fetched less than the page size, mark as no more notifications
        if (fetchedNotifications.length < _pageSize) {
          _hasMoreNotifications = false;
        } else {
          _currentPage++; // Increment page number for the next fetch
        }

        _notifications.addAll(fetchedNotifications);
      });
    } catch (e) {
      print('Error fetching notifications: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load notifications')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Scroll listener to detect when the user reaches the bottom
  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // When the user reaches the bottom, load more data
      if (_hasMoreNotifications) {
        _fetchNotifications();
      }
    }
  }

  /// Marks a notification as read and removes it from the list.
  void _markAsRead(String notificationId) async {
    try {
      await NotificationService(context).markNotificationAsRead(notificationId);

      setState(() {
        _notifications.removeWhere(
                (notification) => notification.notificationId == notificationId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification marked as read')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to mark notification as read')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              setState(() {
                _notifications.clear();
                _currentPage = 0;
                _hasMoreNotifications = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications cleared')),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController, // Attach the scroll controller here
        slivers: [
          // Show shimmer effect while loading
          if (_isLoading)
            SliverToBoxAdapter(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Container(
                    color: Colors.white,
                    height: 70.0, // Set a fixed height for the shimmer
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: const Center(child: Text('Loading...')),
                  ),
                ),
              ),
            ),
          // List of notifications as a sliver list
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                if (index == _notifications.length) {
                  // If reached the end, load more notifications
                  if (_hasMoreNotifications) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Center(child: Text('No more notifications'));
                  }
                }

                final notification = _notifications[index];
                return GestureDetector(
                  onTap: () {
                    // Mark the notification as read
                    _markAsRead(notification.notificationId!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      child: NotificationCard(
                        notification: notification,
                      ),
                    ),
                  ),
                );
              },
              childCount: _notifications.length + 1, // Plus one for loading indicator
            ),
          ),
        ],
      ),
    );
  }
}
