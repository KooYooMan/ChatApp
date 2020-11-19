import 'package:flutter/material.dart';

import 'message.dart';

class TextMessage extends Message {
  String text;
  TextMessage(String uid, String cid, String userDisplayName, ImageProvider avatarProvider, DateTime sentTime, bool seen, String text)
  : super(uid, cid, userDisplayName, avatarProvider, sentTime, seen, MessageType.text) {
    this.text = text;
  }
  @override
  String getContent() {
    return this.text;
  }
}