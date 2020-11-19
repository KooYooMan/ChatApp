import 'package:flutter/material.dart';

enum MessageType {
  text,
  document,
  image,
  audio,
}

class Message {
  String mid;
  String uid;
  String cid;
  String userDisplayName;
  ImageProvider avatarProvider;
  DateTime sentTime;
  bool seen;
  MessageType type;

  Message(String uid, String cid, String userDisplayName, ImageProvider avatarProvider, DateTime sentTime, bool seen, MessageType messageType) {
    this.uid = uid;
    this.cid = cid;
    this.userDisplayName = userDisplayName;
    this.avatarProvider = avatarProvider;
    this.sentTime = sentTime;
    this.seen = seen;
    this.type = messageType;
    print("type = " + this.type.toString());
  }
  String getContent() {
    return "";
  }
}


