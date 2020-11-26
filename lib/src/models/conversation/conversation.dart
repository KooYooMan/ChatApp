import 'package:ChatApp/src/models/user/user.dart';
import 'package:ChatApp/src/models/message/message.dart';
import 'package:flutter/material.dart';

class Conversation {
  String cid;
  String displayName;
  ImageProvider avatarProvider;
  bool isPrivate;
  List<User> users = new List<User>();
  List<Message> messageList = new List<Message>();
  Conversation(String cid, String displayName, ImageProvider avatarProvider, bool isPrivate) {
    this.cid = cid;
    this.displayName = displayName;
    this.avatarProvider = avatarProvider;
    this.isPrivate = isPrivate;
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

