import 'package:flutter/cupertino.dart';

import 'content.dart';

class Message {
  String sender;
  Content content;
  DateTime sentTime;
  Map seen;
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
  }

  @override
  String toString() {
    // TODO: implement toString for files, photos, texts
    return content.text;
  }
}