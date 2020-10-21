import 'dart:io';

import 'package:ChatApp/src/models/user/user.dart';
import 'package:ChatApp/src/models/message/content.dart';
import 'package:ChatApp/src/models/message/message.dart';

class Conversation {
  String _id;
  String _displayName;
  List<User> _users = new List<User>();
  List<Message> _messageList = new List<Message>();
  Conversation(String id, String displayName) {
    this._id = id;
    this._displayName = displayName;
  }
  String get displayName {
    return _displayName;
  }
  set displayName(String newDisplayName) {
    this._displayName = newDisplayName;
  }

  void addMessage(Message message) {
    _messageList.add(message);
  }
  List<Message> get messageList {
    return _messageList;
  }
}

Conversation fakeConversation() {
  Conversation c = Conversation("1", "FakeConversation");
  c.addMessage(Message("0", "1", DateTime.now(), Content(text: "0 message: zzz")));
  sleep(const Duration(seconds: 1));
  c.addMessage(Message("0", "1", DateTime.now(), Content(text: "0 message: ssss")));
  sleep(const Duration(seconds: 1));
  c.addMessage(Message("1", "1", DateTime.now(), Content(text: "1 message: alo alo")));
  return c;
}