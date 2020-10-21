import 'package:flutter/cupertino.dart';

import 'content.dart';

class Message {
  String mid;
  String uid;
  String cid;
  String userDisplayName;
  ImageProvider avatarProvider;
  Content content;
  DateTime sentTime;
  bool seen;
  Message(String uid, String cid, String userDisplayName, ImageProvider avatarProvider, DateTime sentTime, Content content, bool seen) {
    this.uid = uid;
    this.cid = cid;
    this.userDisplayName = userDisplayName;
    this.avatarProvider = avatarProvider;
    this.sentTime = sentTime;
    this.content = content;
    this.seen = seen;
  }
}
