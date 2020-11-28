import 'package:flutter/material.dart';

import 'message.dart';

class TextMessage extends Message {
  TextMessage(String uid, DateTime sentTime, Map seen, String text)
  : super(uid, sentTime, seen, MessageType.text, text) {
  }

  TextMessage.fromSnapshot(String mid, Map data) : super.fromSnapshot(mid, data) {
  }

  @override
  String toString() {
    return this.content;
  }
}