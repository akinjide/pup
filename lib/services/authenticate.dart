import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pup/services/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account.dart';

class AuthenticateService {
  FirebaseServiceDatabase fsdb = FirebaseServiceDatabase();

  Future<bool> create(User record) async {
    DatabaseReference ref = fsdb.database.ref("users");
    User? user = await findUser(record.phoneNumber);
    // user with phone number exist, do not allow
    if (user != null) {
      return false;
    }

    DatabaseReference userRef = ref.push();
    await userRef.set({
      "user_id": userRef.key,
      "full_name": record.fullName,
      "birth_year": record.birthYear,
      "phone_number": record.phoneNumber,
      "pin": record.pin,
      "is_new": record.isNew,
    });

    return true;
  }

  Future<User?> login(String phone, String pin) async {
    final prefs = await SharedPreferences.getInstance();
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
    DatabaseReference ref = fsdb.database.ref("users");
    final snapshot = await ref.get();

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
    var bytes = utf8.encode(value);
    var digest = sha1.convert(bytes);

    print("Digest as bytes: ${digest.bytes}");
    print("Digest as hex string: $digest");

    return digest;
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove('user_id');
  }
}