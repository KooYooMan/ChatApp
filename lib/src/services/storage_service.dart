import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService{
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  StorageService();

  Future<String> getDownloadURL(String filePath) async {
    String result = await _firebaseStorage.ref(filePath).getDownloadURL();
    return result;
  }

  Future<void> uploadFile(File file, String remotePath) async {
    try {
      await _firebaseStorage
          .ref(remotePath)
          .putFile(file);
    } catch (e) {
      print(e);
    }
  }
}