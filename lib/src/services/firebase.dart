import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  DatabaseReference recursiveFindReference(DatabaseReference root, List<String> children) {
    if (children.isEmpty)
      return root;
    return recursiveFindReference(root.child(children[0]), children.sublist(1));
  }

  DatabaseReference getDatabaseReference(List<String> children) {
    if (children.isEmpty)
      return _firebaseDatabase.reference();
    return recursiveFindReference(_firebaseDatabase.reference(), children);
  }

  Future<void> addDocument(DatabaseReference databaseReference, Map object){
    var newRef = databaseReference.push();
    newRef.set(object)
        .then((value) => print("Document Added"))
        .catchError((error) => print("Failed to add document: $error"));
  }

  Future<void> addDocumentCustomId(DatabaseReference databaseReference, String id, Map object) async {
    var newRef = databaseReference.child(id);
    await newRef.set(object)
        .then((value) => print("Document Added"))
        .catchError((error) => print("Failed to add document: $error"));
  }
  
  Future<void> setDocument(DatabaseReference documentReference, Map newObject){
    documentReference
        .set(newObject)
        .then((value) => print("Updated!"))
        .catchError((error) => print("$error"));
  }

  Future<void> updateDocument(DatabaseReference documentReference, Map newObject){
    documentReference
        .update(newObject)
        .then((value) => print("Updated!"))
        .catchError((error) => print("$error"));
  }

  Future<void> deleteDocument(DatabaseReference databaseReference){
    databaseReference.remove();
  }
}