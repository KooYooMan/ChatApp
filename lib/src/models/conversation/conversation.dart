import 'package:ChatApp/src/models/message/message.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ChatApp/src/models/message/content.dart';
import 'package:ChatApp/src/models/message/content.dart';
import 'package:ChatApp/src/services/auth_service.dart';
import 'package:ChatApp/src/services/storage_service.dart';

class Conversation {
  String cid;
  String displayName;
  ImageProvider avatarProvider;
  List<String> users = new List<String>();
  int lastTimestamp;
  Message recentMessage;

  Conversation(String cid) {
    this.cid = cid;
  }

  Conversation.fromSnapshot(Map data){
    AuthService authService = GetIt.I.get<AuthService>();

    String currentUID = authService.getCurrentUID();

    this.recentMessage = Message(data["lastSender"], DateTime.fromMillisecondsSinceEpoch(data['lastTimestamp']), new Content(data['recentMessage']), data['seen']);
    this.lastTimestamp = data['lastTimestamp'];

    data['members'].forEach((key, value) {
      users.add(key);
    });
    if (users.length == 2){
      if (users[0].compareTo(users[1]) > 0){
        String tmp = users[0];
        users[0] = users[1];
        users[1] = tmp;
      }
      this.cid = '${users[0]}-${users[1]}';
      users.forEach((element) {
        if (element != currentUID){
          // this.displayName = element;
          this.displayName = data['members'][element];
        }
      });
    }
    else {
      this.displayName = "Group";
    }
  }
  // void addMessage(Message message) {
  //   for (int i = 0; i < messageList.length; i++) {
  //     if (messageList[i].mid == message.mid) {
  //       messageList[i] = message;
  //       return;
  //     }
  //   }
  //   messageList.add(message);
  //   messageList.sort((a, b) => (a.sentTime.compareTo(b.sentTime)));
  // }
}

