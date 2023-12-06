import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase.dart';

class User {
  final String userID;
  final String fullName;
  final String birthYear;
  final String phoneNumber;
  final String pin;
  final bool isNew;
  final double bmi;

  User({
    required this.userID,
    required this.fullName,
    required this.birthYear,
    required this.phoneNumber,
    required this.pin,
    required this.isNew,
    this.bmi = 0,
  });

  factory User.fromJson(Map<dynamic, dynamic>json) {
    return User(
      userID: json['user_id'],
      fullName: json['full_name'],
      birthYear: json['birth_year'],
      phoneNumber: json['phone_number'],
      pin: json['pin'],
      isNew: json['is_new'],
      bmi: json['bmi'],
    );
  }
}

class AccountService {
  FirebaseServiceDatabase fsdb = FirebaseServiceDatabase();

  Future<bool> update(String? id, Map<String, dynamic>value) async {
    if (id == null) {
      return false;
    }

    DatabaseReference ref = fsdb.database.ref("users/$id");
    await ref.update(value);

    return true;
  }

  Future<bool> isAuthenticated() async {
    String? id = await activeId();

    if (id != null) {
      User? user = await findUserById(id);

      if (user != null) {
        return true;
      }
    }

    return false;
  }

  Future<User?> authUser() async {
    String? id = await activeId();

    if (id != null) {
      return await findUserById(id);
    }

    return null;
  }

  static Future<String?> activeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<User> findUserById(String id) async {
    DatabaseReference ref = fsdb.database.ref("users/$id");
    DataSnapshot snapshot = await ref.get();
    Map<dynamic, dynamic> data = snapshot.value as dynamic;
    return User.fromJson(data);
  }
}