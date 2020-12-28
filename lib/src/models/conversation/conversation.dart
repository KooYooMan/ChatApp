import 'package:ChatApp/src/models/message/document_message.dart';
import 'package:ChatApp/src/models/message/image_message.dart';
import 'package:ChatApp/src/models/message/location_message.dart';
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

  Future<void> loadAvatar() async {
    AuthService authService = GetIt.I.get<AuthService>();
    if (this.users.length == 1) {
      String url = await authService.getAvatarURL(this.users[0]);
      this.avatarProvider = NetworkImage(url);
    }
    if (this.users.length == 2) {
      users.forEach((element) async {
        if (element != authService.getCurrentUID()) {
          authService.getAvatarURL(element).then((url) {
            avatarProvider = NetworkImage(url);
          });
        }
      });
    }
    if (this.users.length > 2 ) {
      this.avatarProvider = NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUaaCmVssmaJOUN81ME-8C0PlRJuAbY_oDOA&usqp=CAU");
    }
  }

  Conversation.fromSnapshot(String cid, Map data) {
    AuthService authService = GetIt.I.get<AuthService>();

    String currentUID = authService.getCurrentUID();
    this.lastSender = data['lastSender'];
    this.isPrivate = false; // TODO : Private conversation

    switch (MessageType.values[data["recentMessageType"]]) {
      case MessageType.location:
        {
          recentMessage = LocationMessage(
              data["lastSender"],
              DateTime.fromMillisecondsSinceEpoch(data['lastTimestamp']),
              data['seen'],
              data['recentMessage'],
              data['latitude'],
              data['longitude']
          );
          break;
        }
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
    this.avatarProvider = NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyEQc0W8lhz-z8b9db7uxEhKtBsnVmQbMIbg&usqp=CAU");
    this.lastTimestamp = data['lastTimestamp'];
    List<String> displayNameList = [];
    this.members = data['members'];
    data['members'].forEach((key, value) {
      displayNameList.add(value);
      members[key] = value;
      users.add(key);
    });
    if (users.length == 2) {
      this.cid = cid;
      users.forEach((element) {
        if (element != currentUID) {
          this.displayName = data['members'][element];
        }
      });
    } else {
      // this.avatarProvider = NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUaaCmVssmaJOUN81ME-8C0PlRJuAbY_oDOA&usqp=CAU");
      this.cid = cid;
      this.displayName = displayNameList[0];
      for (var i = 1; i < displayNameList.length; i++){
        if (i == displayNameList.length - 1)
          this.displayName += " & ${displayNameList[i]}";
        else
          this.displayName += ", ${displayNameList[i]}";
      }
    }
  }
}
