import 'dart:async';
import 'dart:collection';

import 'package:ChatApp/src/models/conversation/conversation.dart';
import 'package:ChatApp/src/services/firebase.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ChatApp/src/models/user/user.dart';

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

  Future<Conversation> addConversation(User firstUser, User secondUser) async {
    print("1st : ${firstUser.uid}");
    print("2nd : ${secondUser.uid}");
    if (firstUser.uid.compareTo(secondUser.uid) > 0){
      var tmp = firstUser;
      firstUser = secondUser;
      secondUser = tmp;
    }

    var conversationId = firstUser.uid + '-' + secondUser.uid;
    var conversationRef = _firebaseService.getDatabaseReference(["conversations"]);

    await _firebaseService.addDocumentCustomId(conversationRef, conversationId, Map<String, dynamic>.from({
      "recentMessage": "",
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
      "members": {
        firstUser.uid: firstUser.displayName,
        secondUser.uid: secondUser.displayName
      },
      "seen": {
        firstUser.uid: true,
        secondUser.uid: true
      }
    }));


    Conversation conversation = null;
    await _firebaseService.getDatabaseReference(["conversations", conversationId]).once().then((snapshot){
      conversation = Conversation.fromSnapshot(snapshot.value);
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