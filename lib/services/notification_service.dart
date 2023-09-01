import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static Future<void> initialize() async {
    NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.requestPermission();
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      debugPrint('Notification Initialized!');
    }
  }
}
