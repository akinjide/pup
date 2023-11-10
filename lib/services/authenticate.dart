import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pup/services/firebase.dart';

class User {
  final String userID;
  final String fullName;
  final String birthYear;
  final String phoneNumber;
  final String pin;
  final bool isNew;

  User({
    required this.userID,
    required this.fullName,
    required this.birthYear,
    required this.phoneNumber,
    required this.pin,
    required this.isNew,
  });

  factory User.fromJson(Map<dynamic, dynamic>json) {
    return User(
      userID: json['user_id'],
      fullName: json['full_name'],
      birthYear: json['birth_year'],
      phoneNumber: json['phone_number'],
      pin: json['pin'],
      isNew: json['is_new'],
    );
  }
}

class AuthenticateService {
  FirebaseServiceDatabase fsdb = FirebaseServiceDatabase();

  Future<bool> create(String fullName, String birthYear, String phone, String pin) async {
    DatabaseReference ref = fsdb.database.ref("users");
    User? user = await findUser(phone);

    // user with phone number exist, do not allow
    if (user != null) {
      return false;
    }

    DatabaseReference userRef = ref.push();

    await userRef.set({
      "user_id": userRef.key,
      "full_name": fullName,
      "birth_year": birthYear,
      "phone_number": phone,
      "pin": pin,
      "is_new": true,
    });

    return true;
  }

  Future<User?> login(String phone, String pin) async {
    User? user = await findUser(phone);

    if (user != null) {
      if (user.pin == pin) {
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
}