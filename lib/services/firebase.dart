import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  FirebaseServiceDatabase database = FirebaseServiceDatabase();
  FirebaseServiceStorage storage = FirebaseServiceStorage();
}

class FirebaseServiceDatabase {
  FirebaseDatabase database = FirebaseDatabase.instance;
}

class FirebaseServiceStorage {
  FirebaseStorage storage = FirebaseStorage.instance;
}
