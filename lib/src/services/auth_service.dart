import 'package:ChatApp/src/services/firebase.dart';
import 'package:ChatApp/src/services/storage_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:ChatApp/src/services/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ChatApp/src/services/storage_service.dart';


class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  StorageService _storageService = GetIt.I.get<StorageService>();

  Stream<User> get onAuthStateChanged => _firebaseAuth.authStateChanges();

  User getCurrentUser(){
    return _firebaseAuth.currentUser;
  }

  String getCurrentUID(){
    if (_firebaseAuth.currentUser != null)
      return _firebaseAuth.currentUser.uid;
    else
      return null;
  }

  Future<String> signIn(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return result.user.uid;
    } on FirebaseAuthException catch (e) {
      return Future.error(e);
    }
  }
  
  String getDisplayName(String uid){
    var query = _firebaseService.getDatabaseReference(["users", uid, "displayName"]);
    query.once().then((value) {
      return value;
    });
  }

  Future<String> signUp(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(
          email: email, password: password);

      DatabaseReference users = _firebaseService.getDatabaseReference(["users"]);
      _firebaseService.addDocumentCustomId(users, result.user.uid, {
        "isOnline": true
      });

      // set default avatar
      _storageService.getDownloadURL('Anonymous-Avatar.png').then((url){
        getCurrentUser().updateProfile(photoURL: url, displayName: email);
        var ref = _firebaseService.getDatabaseReference(["users", result.user.uid]);
        _firebaseService.updateDocument(ref, Map<String, dynamic>.from({
          "photoURL": url
        }));
        getCurrentUser().reload();
      });

      return result.user.uid;
    } on FirebaseAuthException catch (e) {
      return Future.error(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}