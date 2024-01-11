import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onpods/utils/notification_service.dart';

void setupFirebaseMessaging() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("onMessage: $message");
    // Handle the foreground message, e.g., show an in-app notification
    NotificationService.showNotification(
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
    );
  });

  FirebaseMessaging.onBackgroundMessage(
      (RemoteMessage message) => NotificationService.showNotification(
            title: message.notification?.title ?? '',
            body: message.notification?.body ?? '',
            bigPicture: message.data['poster'] ?? ''
          ));


  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   print("onMessageOpenedApp: $message");
  //   // Handle the opening of the app from a terminated state
  //   NotificationService.showNotification(
  //      title: message.notification?.title ?? '',
  //           body: message.notification?.body ?? '',
  //           bigPicture: message.data['poster'] ?? '',

  //   );
  // });
}
