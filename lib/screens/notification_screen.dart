import 'package:flutter/material.dart';
import 'package:onpods/utils/colors.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});

  // Example list of notifications
  final List<NotificationItem> notifications = [
    NotificationItem(
      notification: 'You have a new message.',
      iconData: Icons.message, // Message icon
    ),
    NotificationItem(
      notification: 'You received a friend request.',
      iconData: Icons.person_add, // Friend request icon
    ),
    NotificationItem(
      notification: 'Event reminder: Meeting at 2 PM.',
      iconData: Icons.event, // Meeting icon
    ),
    NotificationItem(
      notification: 'Your post got a new comment.',
      iconData: Icons.comment, // Comment icon
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today',
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return NotificationCard(
                    notification: notification.notification,
                    iconData: notification.iconData,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationItem {
  final String notification;
  final IconData iconData;

  NotificationItem({required this.notification, required this.iconData});
}

class NotificationCard extends StatelessWidget {
  final String notification;
  final IconData iconData;

  const NotificationCard(
      {super.key, required this.notification, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: blueColor,
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
        title: Text(
          notification,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16.0,
          ),
        ),
        onTap: () {
          // Handle notification click action here
        },
      ),
    );
  }
}
