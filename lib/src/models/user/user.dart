import 'package:flutter/material.dart';

class User {
  String uid;
  String displayName;
  ImageProvider avatarProvider;
  User(String uid, String displayName, ImageProvider avatarProvider) {
    this.uid = uid;
    this.displayName = displayName;
    this.avatarProvider = avatarProvider;
  }

}
