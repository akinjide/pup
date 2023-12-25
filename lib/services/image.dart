import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'firebase.dart';

class ImageService {
  FirebaseServiceStorage fss = FirebaseServiceStorage();

  Future<String?> upload(XFile? file, String path) async {
    Reference ref = fss.storage.ref(path);

    try {
      File image = File(file!.path);
      TaskSnapshot snapshot = await ref.putFile(image);

      if (snapshot.state == TaskState.success) {
        return await snapshot.ref.getDownloadURL();
      } else if (snapshot.state == TaskState.error) {
        print('error');
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}