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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             EmptyPlaceHolder(message: "No")
            ],
          ),
        ),
      ),
    );
  }
}
