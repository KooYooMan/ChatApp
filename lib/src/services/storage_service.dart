import 'package:firebase_storage/firebase_storage.dart';

class StorageService{
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  StorageService();

  Future<String> getDownloadURL(String filePath) async {
    String result = await _firebaseStorage.ref(filePath).getDownloadURL();
    return result;
  }
}