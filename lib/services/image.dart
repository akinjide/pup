import 'package:firebase_storage/firebase_storage.dart';

import 'firebase.dart';

class ImageService {
  FirebaseServiceStorage fss = FirebaseServiceStorage();

  void upload() async {
    Reference ref = fss.storage.ref();
    print(ref.bucket);
    //
    // try {
    //   // await ref.putFile();
    // } on FirebaseException catch (e) {
    //   // ...
    // }
  }
}