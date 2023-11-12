import 'package:flutter/material.dart';


class SnackBarNotification {
  SnackBarNotification._();

  static GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static notify(String message) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      action: SnackBarAction(
        label: 'dismiss',
        textColor: Colors.black,
        backgroundColor: Colors.white,
        onPressed: () {},
      ),
    ));
  }
}