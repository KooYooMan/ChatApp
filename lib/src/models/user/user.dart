import 'package:flutter/material.dart';

class User {
  String uid;
  String email;
  String displayName;
  bool isOnline;
  ImageProvider avatarProvider;
  User(String uid, String displayName, ImageProvider avatarProvider) {
    this.uid = uid;
    this.displayName = displayName;
    this.avatarProvider = avatarProvider;
  }

  User.fromSnapshot(String uid, Map data){
    this.uid = uid;
    this.displayName = data['displayName'];
    this.email = data['email'];
    this.isOnline = data['isOnline'];
    this.avatarProvider = NetworkImage(data['photoURL']);
  }
}
