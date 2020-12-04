import 'dart:async';
import 'dart:collection';

import 'package:ChatApp/src/models/conversation/conversation.dart';
import 'package:ChatApp/src/models/message/message.dart';
import 'package:ChatApp/src/services/firebase.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ChatApp/src/models/user/user.dart';

import 'package:uuid/uuid.dart';

class MessageService {
  FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();

  void addDocumentMessage(Conversation conversation, String senderId, String url, String filename){
    var timestamp = DateTime.now().millisecondsSinceEpoch;

    var messagesRef = _firebaseService.getDatabaseReference(["messages", conversation.cid]);
    _firebaseService.addDocumentCustomId(messagesRef, timestamp.toString(), {
      "type": MessageType.document.index,
      "content": url,
      "sender": senderId,
      "docName": filename,
      "seenList": []
    });

    var conversationRef = _firebaseService.getDatabaseReference(["conversations", conversation.cid]);
    _firebaseService.updateDocument(conversationRef, Map<String, dynamic>.from({
      "recentMessageType": MessageType.document.index,
      "recentMessage": url,
      "lastTimestamp": timestamp,
      "docName": filename,
      "lastSender": senderId
    }));

    conversation.users.forEach((uid) {
      var userConversationRef = _firebaseService.getDatabaseReference(["users/$uid/conversations/${conversation.cid}"]);
      _firebaseService.updateDocument(userConversationRef, Map<String, dynamic>.from({
        "recentMessageType": MessageType.document.index,
        "recentMessage": url,
        "lastTimestamp": timestamp,
        "docName": filename,
        "lastSender": senderId
      }));
    });

    seenNewMessage(conversation, senderId, timestamp);
  }

  void addImageMessage(Conversation conversation, String senderId, String url){
    var timestamp = DateTime.now().millisecondsSinceEpoch;

    var messagesRef = _firebaseService.getDatabaseReference(["messages", conversation.cid]);
    _firebaseService.addDocumentCustomId(messagesRef, timestamp.toString(), {
      "type": MessageType.image.index,
      "content": url,
      "sender": senderId,
      "seenList": []
    });

    var conversationRef = _firebaseService.getDatabaseReference(["conversations", conversation.cid]);
    _firebaseService.updateDocument(conversationRef, Map<String, dynamic>.from({
      "recentMessageType": MessageType.image.index,
      "recentMessage": url,
      "lastTimestamp": timestamp,
      "lastSender": senderId
    }));

    conversation.users.forEach((uid) {
      var userConversationRef = _firebaseService.getDatabaseReference(["users/$uid/conversations/${conversation.cid}"]);
      _firebaseService.updateDocument(userConversationRef, Map<String, dynamic>.from({
        "recentMessageType": MessageType.image.index,
        "recentMessage": url,
        "lastTimestamp": timestamp,
        "lastSender": senderId
      }));
    });

    seenNewMessage(conversation, senderId, timestamp);
  }

  void addTextMessage(Conversation conversation, String senderId, String content){
    if (content.trim() == "")
      return;

    var timestamp = DateTime.now().millisecondsSinceEpoch;

    var messagesRef = _firebaseService.getDatabaseReference(["messages", conversation.cid]);
    _firebaseService.addDocumentCustomId(messagesRef, timestamp.toString(), {
      "type": MessageType.text.index,
      "content": content,
      "sender": senderId,
      "seenList": []
    });

    var conversationRef = _firebaseService.getDatabaseReference(["conversations", conversation.cid]);
    _firebaseService.updateDocument(conversationRef, Map<String, dynamic>.from({
      "recentMessageType": MessageType.text.index,
      "recentMessage": content,
      "lastTimestamp": timestamp,
      "lastSender": senderId
    }));

    conversation.users.forEach((uid) {
      var userConversationRef = _firebaseService.getDatabaseReference(["users/$uid/conversations/${conversation.cid}"]);
      _firebaseService.updateDocument(userConversationRef, Map<String, dynamic>.from({
        "recentMessageType": MessageType.text.index,
        "recentMessage": content,
        "lastTimestamp": timestamp,
        "lastSender": senderId
      }));
    });

    seenNewMessage(conversation, senderId, timestamp);
  }

  void seenNewMessage(Conversation conversation, String senderId, int timestamp){
    var ref = _firebaseService.getDatabaseReference(["conversations", conversation.cid, "seen"]);

    conversation.users.forEach((user) {
      if (user != senderId)
        _firebaseService.updateDocument(ref, Map<String, dynamic>.from({
          user: false
        }));
      else
        _firebaseService.updateDocument(ref, Map<String, dynamic>.from({
          user: true
        }));
    });

    var messRef = _firebaseService.getDatabaseReference(["messages", conversation.cid, timestamp.toString(), "seen"]);
    _firebaseService.setDocument(messRef, {
      senderId: true
    });
  }

  Stream<Event> getMessages(String conversationId){
    var query = _firebaseService.getDatabaseReference(["messages", conversationId]).orderByKey();
    return query.onValue;
  }

  Future<Conversation> addGroupConversation(List<User> users) async {
    var uuid = Uuid();
    var conversationId = uuid.v4();

    var conversationRef = _firebaseService.getDatabaseReference(["conversations"]);

    Conversation conversation = null;
    await _firebaseService.getDatabaseReference(["conversations", conversationId]).once().then((snapshot){
      if (snapshot.value != null)
        conversation = Conversation.fromSnapshot(conversationId, snapshot.value);
    });

    if (conversation != null)
      return conversation;

    Map members = new Map();
    Map seen = new Map();
    users.forEach((user) {
      members[user.uid] = user.displayName;
      seen[user.uid] = true;
    });

    await _firebaseService.addDocumentCustomId(conversationRef, conversationId, Map<String, dynamic>.from({
      "recentMessage": "",
      "recentMessageType": 0,
      "lastTimestamp": -1,
      "members": members,
      "seen": seen
    }));

    users.forEach((user) async {
      var messRef = _firebaseService.getDatabaseReference(["users", user.uid, "conversations", conversationId]);
      await _firebaseService.updateDocument(messRef, Map<String, dynamic>.from({
        "recentMessage": "",
        "lastTimestamp": -1,
        "recentMessageType": 0,
        "members": members,
        "seen": seen
      }));
    });

    await _firebaseService.getDatabaseReference(["conversations", conversationId]).once().then((snapshot){
      print(snapshot.value);
      conversation = Conversation.fromSnapshot(conversationId, snapshot.value);
    });

    return conversation;
  }

  Future<Conversation> addConversation(User firstUser, User secondUser) async {
    if (firstUser.uid.compareTo(secondUser.uid) > 0){
      var tmp = firstUser;
      firstUser = secondUser;
      secondUser = tmp;
    }

    var conversationId = firstUser.uid + '-' + secondUser.uid;
    var conversationRef = _firebaseService.getDatabaseReference(["conversations"]);

    Conversation conversation = null;
    await _firebaseService.getDatabaseReference(["conversations", conversationId]).once().then((snapshot){
      if (snapshot.value != null)
        conversation = Conversation.fromSnapshot(conversationId, snapshot.value);
    });

    if (conversation != null)
      return conversation;

    await _firebaseService.addDocumentCustomId(conversationRef, conversationId, Map<String, dynamic>.from({
      "recentMessage": "",
      "recentMessageType": 0,
      "lastTimestamp": -1,
      "members": {
        firstUser.uid: firstUser.displayName,
        secondUser.uid: secondUser.displayName
      },
      "seen": {
        firstUser.uid: true,
        secondUser.uid: true
      }
    }));

    var messRef = _firebaseService.getDatabaseReference(["users", firstUser.uid, "conversations", conversationId]);
    await _firebaseService.updateDocument(messRef, Map<String, dynamic>.from({
      "recentMessage": "",
      "lastTimestamp": -1,
      "recentMessageType": 0,
      "members": {
        firstUser.uid: firstUser.displayName,
        secondUser.uid: secondUser.displayName
      },
      "seen": {
        firstUser.uid: true,
        secondUser.uid: true
      }
    }));

    messRef = _firebaseService.getDatabaseReference(["users", secondUser.uid, "conversations", conversationId]);
    await _firebaseService.updateDocument(messRef, Map<String, dynamic>.from({
      "recentMessage": "",
      "lastTimestamp": -1,
      "recentMessageType": 0,
      "members": {
        firstUser.uid: firstUser.displayName,
        secondUser.uid: secondUser.displayName
      },
      "seen": {
        firstUser.uid: true,
        secondUser.uid: true
      }
    }));

    await _firebaseService.getDatabaseReference(["conversations", conversationId]).once().then((snapshot){
      print(snapshot.value);
      conversation = Conversation.fromSnapshot(conversationId, snapshot.value);
    });

    return conversation;
  }

  void seenConversation(Conversation conversation, String user) {
    conversation.recentMessage.seen[user] = true;
    var ref = _firebaseService.getDatabaseReference(["conversations", conversation.cid, "seen"]);
    _firebaseService.updateDocument(ref, Map<String, dynamic>.from({
      user: true
    }));

    var messRef = _firebaseService.getDatabaseReference(["messages", conversation.cid, conversation.lastTimestamp.toString(), "seen"]);
    _firebaseService.setDocument(messRef, {
      user: true
    });
  }

  Stream<Event> getRecentConversations(String uid){
    var query = _firebaseService.getDatabaseReference(["users/$uid/conversations"]);
    return query.onValue;
  }

  Query getConversationById(String cid) {
    var result = _firebaseService.getDatabaseReference(["conversations/$cid"]);
    return result;
  }
}