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
  final String weight;
  final String weightUnit;
  final String height;
  final String heightUnit;

  User({
    required this.userID,
    required this.fullName,
    required this.birthYear,
    required this.phoneNumber,
    required this.pin,
    required this.isNew,
    this.bmi = 0,
    this.weight = '',
    this.weightUnit = '',
    this.height = '',
    this.heightUnit = '',
  });

  factory User.fromJson(Map<dynamic, dynamic>json) {
    return User(
      userID: json['user_id'],
      fullName: json['full_name'],
      birthYear: json['birth_year'],
      phoneNumber: json['phone_number'],
      pin: json['pin'],
      isNew: json['is_new'],
      bmi: json['bmi'] ?? 0,
      weight: json['weight'] ?? '',
      weightUnit: json['weight_unit'] ?? '',
      height: json['height'] ?? '',
      heightUnit: json['height_unit'] ?? '',
    );
  }
}

class Doctor {
  final String doctorID;
  final String fullName;
  final String phoneNumber;

  Doctor({
    required this.doctorID,
    required this.fullName,
    required this.phoneNumber,
  });

  factory Doctor.fromJson(Map<dynamic, dynamic>json) {
    return Doctor(
      doctorID: json['doctor_id'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
    );
  }
}

class AccountService {
  FirebaseServiceDatabase fsdb = FirebaseServiceDatabase();

  Future<bool> update(String? id, Map<String, dynamic>value) async {
    if (id == null) {
      return false;
    }

    DatabaseReference userRef = fsdb.database.ref('users/$id');
    await userRef.update(value);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<User> findUserById(String id) async {
    DatabaseReference ref = fsdb.database.ref('users/$id');
    DataSnapshot snapshot = await ref.get();
    Map<dynamic, dynamic> data = snapshot.value as dynamic;
    return User.fromJson(data);
  }

  Future<bool> addDoctor(Doctor doctor, String userId) async {
    DatabaseReference ref = fsdb.database.ref('doctors/$userId');
    DatabaseReference doctorRef = ref.push();

    await doctorRef.set({
      'doctor_id': doctorRef.key,
      'full_name': doctor.fullName,
      'phone_number': doctor.phoneNumber,
    });

    return true;
  }

  Future<List<Doctor>> getDoctors() async {
    String? userId = await AccountService.activeId();
    DatabaseReference doctorsRef = fsdb.database.ref('doctors/$userId');
    DataSnapshot snapshot = await doctorsRef.get();
    List<Doctor> doctors = [];

    if (snapshot.exists) {
      for (final child in snapshot.children) {
        Map<dynamic, dynamic> data = child.value as dynamic;
        doctors.add(Doctor.fromJson(data));
      }

      return doctors;
    }

    return doctors;
  }

  Future<bool> delete() async {
    String? userId = await AccountService.activeId();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DatabaseReference doctorsRef = fsdb.database.ref('doctors/$userId');
    DatabaseReference recordsRef = fsdb.database.ref('records/$userId');
    DatabaseReference userRef = fsdb.database.ref('users/$userId');

    await doctorsRef.remove();
    await recordsRef.remove();
    await userRef.remove();

    return await prefs.remove('user_id');
  }

  static double calculateBMI(String heightValue, String weightValue, String heightUnit, String weightUnit) {
    double height = double.parse(heightValue);
    double weight = double.parse(weightValue);

    if (height == 0 || weight == 0) {
      return -1;
    }

    // Imperial Unit
    if (heightUnit == 'in' && weightUnit == 'lbs') {
      return (((weight * 703) / height) / height);
      // Metric Unit
    } else if (heightUnit == 'm' && weightUnit == 'kg') {
      return weight / (height * height);
    } else {
      return -1;
    }
  }
}