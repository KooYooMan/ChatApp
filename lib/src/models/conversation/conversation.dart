import 'package:ChatApp/src/models/message/document_message.dart';
import 'package:ChatApp/src/models/message/image_message.dart';
import 'package:ChatApp/src/models/message/message.dart';
import 'package:ChatApp/src/models/message/text_message.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ChatApp/src/services/auth_service.dart';

class Conversation {
  String cid;
  String displayName;
  String lastSender;
  ImageProvider avatarProvider;
  bool isPrivate;
  // List<User> users = new List<User>();
  List<Message> messageList = new List<Message>();
  Map members = new Map();
  List<String> users = new List<String>();
  int lastTimestamp;
  Message recentMessage;

  // Conversation(String cid) {
  //   this.cid = cid;
  //   this.displayName = displayName;
  //   this.avatarProvider = avatarProvider;
  //   this.isPrivate = isPrivate;
  // }

  Conversation.fromSnapshot(String cid, Map data) {
    AuthService authService = GetIt.I.get<AuthService>();

    String currentUID = authService.getCurrentUID();
    this.lastSender = data['lastSender'];
    this.isPrivate = false; // TODO : Private conversation

    switch (MessageType.values[data["recentMessageType"]]) {
      case MessageType.text:
        {
          recentMessage = TextMessage(
              data["lastSender"],
              DateTime.fromMillisecondsSinceEpoch(data['lastTimestamp']),
              data['seen'],
              data['recentMessage']);
          break;
        }
      case MessageType.image:
        {
          recentMessage = ImageMessage(
              data["lastSender"],
              DateTime.fromMillisecondsSinceEpoch(data['lastTimestamp']),
              data['seen'],
              data['recentMessage']);
          break;
        }
      case MessageType.document:
        {
          recentMessage = DocumentMessage(
              data["lastSender"],
              DateTime.fromMillisecondsSinceEpoch(data['lastTimestamp']),
              data['seen'],
              data['docName'],
              data['recentMessage']);
          break;
        }
      default:
        break;
    }

    this.lastTimestamp = data['lastTimestamp'];
    List<String> displayNameList = [];
    data['members'].forEach((key, value) {
      displayNameList.add(value);
      members[key] = value;
      users.add(key);
    });
    if (users.length == 2) {
      if (users[0].compareTo(users[1]) > 0) {
        String tmp = users[0];
        users[0] = users[1];
        users[1] = tmp;
      }
      this.cid = '${users[0]}-${users[1]}';
      users.forEach((element) {
        if (element != currentUID) {
          // this.displayName = element;
          this.displayName = data['members'][element];
        }
      });
    } else {
      this.cid = cid;
      this.displayName =
          "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
      // this.displayName = displayNameList[0];
      // for (var i = 1; i < displayNameList.length; i++){
      //   if (i == displayNameList.length - 1)
      //     this.displayName += ", ${displayNameList[i]}";
      //   else
      //     this.displayName += ", ${displayNameList[i]}";
      // }
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
