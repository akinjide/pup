import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/widgets/snackbar.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void onDidReceiveNotificationResponse(NotificationResponse payload) async {
    SnackBarNotification.navigatorKey.currentState?.pushReplacementNamed('/home');
  }

  static NotificationDetails notificationDetails() {
    DarwinNotificationDetails iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'pup-unique-id',
      'PUP channel',
      importance: Importance.max,
      priority: Priority.high,
    );
    return NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  }

  static void schedule(RepeatInterval interval) async {
    await NotificationService.flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'Pressure Relieve Reminder',
      'Any injury to the skin? Log now and we will monitor and show you daily changes and improvements.',
      interval,
      NotificationService.notificationDetails(),
    );
  }

  static void cancelSchedule() async {
    await NotificationService.flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<String> setReminder(String interval) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('reminder', interval);
    return interval;
  }

  static Future<String> getReminder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? remind = prefs.getString('reminder');

    if (remind != null) {
      return remind;
    }

    return NotificationService.setReminder('Day');
  }

  static void show(int id, String title, String body) async {
    await NotificationService.flutterLocalNotificationsPlugin.show(id, title, body, NotificationService.notificationDetails());
  }
}

