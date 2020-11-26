import 'dart:async';
import 'dart:collection';

import 'package:ChatApp/src/models/conversation/conversation.dart';
import 'package:ChatApp/src/services/firebase.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MessageService {
  FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();

  void addMessage(Conversation conversation, String senderId, String content){
    if (content.trim() == "")
      return;

    var timestamp = DateTime.now().millisecondsSinceEpoch;

    var messagesRef = _firebaseService.getDatabaseReference(["messages", conversation.cid]);
    _firebaseService.addDocumentCustomId(messagesRef, timestamp.toString(), {
      "content": content,
      "sender": senderId,
      "seenList": []
    });

    var conversationRef = _firebaseService.getDatabaseReference(["conversations", conversation.cid]);
    _firebaseService.updateDocument(conversationRef, Map<String, dynamic>.from({
      "recentMessage": content,
      "lastTimestamp": timestamp,
      "lastSender": senderId
    }));

    conversation.users.forEach((uid) {
      var userConversationRef = _firebaseService.getDatabaseReference(["users/$uid/conversations/${conversation.cid}"]);
      _firebaseService.updateDocument(userConversationRef, Map<String, dynamic>.from({
        "recentMessage": content,
        "lastTimestamp": timestamp,
        "lastSender": senderId
      }));
    });

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

  void addConversation(String firstUserId, String secondUserId){
    if (firstUserId.compareTo(secondUserId) > 0){
      var tmp = firstUserId;
      firstUserId = secondUserId;
      secondUserId = tmp;
    }

    var conversationId = firstUserId + '-' + secondUserId;
    var conversationRef = _firebaseService.getDatabaseReference(["conversations", conversationId]);

    _firebaseService.updateDocument(conversationRef, Map<String, dynamic>.from({
      "recentMessage": "",
      "lastTimestamp": 0
    }));
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