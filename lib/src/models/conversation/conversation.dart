import 'package:ChatApp/src/models/user/user.dart';
import 'package:ChatApp/src/models/message/message.dart';
import 'package:flutter/material.dart';

class Conversation {
  String cid;
  String displayName;
  ImageProvider avatarProvider;
  List<User> users = new List<User>();
  List<Message> messageList = new List<Message>();
  Conversation(String cid, String displayName, ImageProvider avatarProvider) {
    this.cid = cid;
    this.displayName = displayName;
    this.avatarProvider = avatarProvider;
  }
  void addMessage(Message message) {
    for (int i = 0; i < messageList.length; i++) {
      if (messageList[i].mid == message.mid) {
        messageList[i] = message;
        return;
      }
    }
    messageList.add(message);
    messageList.sort((a, b) => (a.sentTime.compareTo(b.sentTime)));
  }
}

