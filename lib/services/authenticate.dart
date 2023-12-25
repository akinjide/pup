import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pup/services/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account.dart';
import 'notification.dart';

class AuthenticateService {
  FirebaseServiceDatabase fsdb = FirebaseServiceDatabase();

  Future<bool> create(User record) async {
    DatabaseReference ref = fsdb.database.ref('users');
    User? user = await findUser(record.phoneNumber);
    // user with phone number exist, do not allow
    if (user != null) {
      return false;
    }

    DatabaseReference userRef = ref.push();
    await userRef.set({
      'user_id': userRef.key,
      'full_name': record.fullName,
      'birth_year': record.birthYear,
      'phone_number': record.phoneNumber,
      'pin': record.pin,
      'is_new': record.isNew,
    });
    await NotificationService.setReminder('Day');

    NotificationService.cancelSchedule();
    NotificationService.schedule(RepeatInterval.daily);

    return true;
  }

  Future<User?> login(String phone, String pin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user = await findUser(phone);

    if (user != null) {
      if (user.pin == pin) {
        await prefs.setString('user_id', user.userID);
        return user;
      }
    }

    return null;
  }

  Future<User?> findUser(String phone) async {
    DatabaseReference ref = fsdb.database.ref('users');
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      for (final child in snapshot.children) {
        Map<dynamic, dynamic> data = child.value as dynamic;
        User user = User.fromJson(data);

        if (phone == user.phoneNumber) {
          return user;
        }
      }
    }

    return null;
  }

  Digest encrypt(String value) {
    List<int> bytes = utf8.encode(value);
    Digest digest = sha1.convert(bytes);

    print('Digest as bytes: ${digest.bytes}');

    return digest;
  }

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove('user_id');
  }
}