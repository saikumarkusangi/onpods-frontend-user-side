import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:onpods/utils/colors.dart';
import 'package:onpods/utils/exports.dart';
import 'package:onpods/utils/notification_service.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       bottomNavigationBar: const MiniPlayer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Announcements',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomElevatedButton(
              text: 'Normal Notification',
              onTap: () async {
                await NotificationService.showNotification(
                    title: 'Hello', body: 'Body');
              },
            ),
            CustomElevatedButton(
              text: ' Notification with summary',
              onTap: () async {
                await NotificationService.showNotification(
                    title: 'Hello',
                    body: 'Body',
                    summary: 'samll summary',
                    notificationLayout: NotificationLayout.Inbox);
              },
            ),
            CustomElevatedButton(
              text: 'progress bar notifcatoin',
              onTap: () async {
                await NotificationService.showNotification(
                    title: 'Hello',
                    body: 'Body',
                    summary: 'samll summary',
                    notificationLayout: NotificationLayout.ProgressBar);
              },
            ),
            CustomElevatedButton(
              text: ' Notification with summary',
              onTap: () async {
                await NotificationService.showNotification(
                    title: 'Hello',
                    body: 'Body',
                    summary: 'samll summary',
                    notificationLayout: NotificationLayout.BigPicture,
                    bigPicture:
                        'https://images-platform.99static.com/5GhOJOUi6vANL1tD2-7bUEhBKgk=/2x0:2000x1998/500x500/top/smart/99designs-contests-attachments/120/120272/attachment_120272240');
              },
            ),
            CustomElevatedButton(
              text: 'action button',
              onTap: () async {
                await NotificationService.showNotification(
                  title: 'Hello',
                  body: 'Body',
                  summary: 'samll summary',
                  payload: {'navigate': 'true'},
                  actionButton: [
                    NotificationActionButton(
                        key: 'check',
                        label: 'check it out',
                        actionType: ActionType.SilentAction)
                  ],
                );


              },
            ),
             CustomElevatedButton(
                    text: 'media button',
                    onTap: () async {
                      await NotificationService.showNotification(
                          title: 'Hello',
                          body: 'Body',
                          summary: 'samll summary',
                          payload: {'navigate': 'true'},
                          actionButton: [
                            NotificationActionButton(
                                key: 'check',
                                label: 'check it out',
                                actionType: ActionType.SilentAction)
                          ],
                          notificationLayout: NotificationLayout.MediaPlayer);
                    })
          ],
        ),
      ),
    );
  }
}
