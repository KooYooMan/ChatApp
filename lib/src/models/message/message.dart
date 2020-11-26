import 'package:flutter/material.dart';

enum MessageType {
  text,
  document,
  image,
  audio,
}

class Message {
  String sender;
  Content content;
  DateTime sentTime;
  Map seen;
  MessageType type;
  Message(String sender, DateTime sentTime, Content content, Map seen) {
    this.sender = sender;
    this.sentTime = sentTime;
    this.content = content;
    this.seen = seen;
  }

  Message.fromSnapshot(String mid, Map data){
    this.sender = data['sender'];
    this.content = Content(data['content']);
    this.sentTime = DateTime.fromMillisecondsSinceEpoch(int.parse(mid));
    this.seen = data['seen'];
    this.type = messageType;
    print("type = " + this.type.toString());
  }

  @override
  String toString() {
    // TODO: implement toString for files, photos, texts
    return content.text;
  }
}