import 'dart:typed_data';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:onpods/utils/colors.dart';
import 'package:onpods/utils/exports.dart';

class NotificationService {
  static Future<void> dismissAllNotifications() async {
    await AwesomeNotifications().dismissAllNotifications();
  }

  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelGroupKey: 'high_importance_channel',
              channelKey: 'high_importance_channel',
              channelName: 'Basic notification',
              channelDescription: 'Notifcation channel for test',
              ledColor: blueColor,
              importance: NotificationImportance.Max,
              channelShowBadge: true,
              onlyAlertOnce: true,
              playSound: true,
              criticalAlerts: true,
              enableVibration: true,
              vibrationPattern: lowVibrationPattern)
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'high_importance_channel',
              channelGroupName: 'Group 1')
        ],
        debug: true);
    await AwesomeNotifications().isNotificationAllowed().then((value) async {
      if (!value) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod);
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    print('notification created');
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    print('notification displayed');
  }

  static Future<void> onActionReceivedMethod(
      ReceivedNotification receivedNotification) async {
    print('notification received');
    final payload = receivedNotification.payload ?? {};
    if (payload['navigate'] == 'true') {
      if (payload['to'] == 'downloads') {
        Get.to(const DownloadsPage());
      }
    }
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedNotification receivedNotification) async {
    print('notification dismissed');
  }

  static Future<void> showNotification(
      {required final String title,
      required final String body,
      final String? summary,
      final Map<String, String>? payload,
      final ActionType actionType = ActionType.Default,
      final NotificationLayout notificationLayout = NotificationLayout.Default,
      final String? bigPicture,
      final List<NotificationActionButton>? actionButton,
      final bool scheduled = false,
      final int? interval,
      final bool locked = false,
      final String? icon,
      final NotificationCategory? category}) async {
    await AwesomeNotifications().isNotificationAllowed().then((value) async {
      if (!value) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: -1,
          channelKey: 'high_importance_channel',
          title: title,
          body: body,
          locked: locked,
          summary: summary,
          bigPicture: bigPicture,
          payload: payload,
          icon: icon,
          actionType: actionType,
          notificationLayout: notificationLayout,
          category: category,
        ),
        schedule: scheduled
            ? NotificationInterval(
                interval: interval,
                timeZone:
                    await AwesomeNotifications().getLocalTimeZoneIdentifier(),
                preciseAlarm: true)
            : null);
  }
}
