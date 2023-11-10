import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  FirebaseServiceDatabase database = FirebaseServiceDatabase();
  // FirebaseServiceDatabase database = FirebaseServiceDatabase();
}

class FirebaseServiceDatabase {
  FirebaseDatabase database = FirebaseDatabase.instance;
}

class FirebaseServiceStorage {

}
