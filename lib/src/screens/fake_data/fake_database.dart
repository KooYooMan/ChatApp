import 'dart:core';
import 'dart:ui';

import 'package:ChatApp/src/models/conversation/conversation.dart';
import 'package:ChatApp/src/models/message/document_message.dart';
import 'package:ChatApp/src/models/message/image_message.dart';
import 'package:ChatApp/src/models/message/message.dart';
import 'package:ChatApp/src/models/message/text_message.dart';
import 'package:ChatApp/src/models/user/user.dart';
import 'package:ChatApp/src/utils/emoji_converter.dart';

import 'package:flutter/material.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
class FakeDatabase {
  List<User> users = List<User>();
  List<Message> messages = List<Message>();
  List<Message> recentlyMessages = List<Message>();
  List<Conversation> conversations = List<Conversation>();
  List<ImageProvider> imageProviders = List<ImageProvider>();

  int maxMid = 0;
  List<Message> getMessagesByCid(String cid) {
    print("cid = " + cid);
    List<Message> results = List<Message>();
    for (int i = 0; i < messages.length; i++) {
      if (messages[i].cid == cid) {
        results.add(messages[i]);
      }
    }
    print("length = ");
    print(results.length);

    return results;
  }
  Stream<Message> getMessageStreamByCid(String cid) async* {
    List<Message> cidMessages = getMessagesByCid(cid);
    print("messages");
    print(cidMessages.length);
    for (var message in cidMessages) {
      print("XXXXXXXX");
      yield message;
      await Future.delayed(Duration(seconds: 2));
    }
  }
  Conversation getConversationByCid(String cid) {
    for (var conversation in conversations) {
      if (conversation.cid == cid) {
        return conversation;
      }
    }
    return getRandomConversation();
  }
  Conversation getRandomConversation() {
    print(conversations.length);
    if (conversations.isNotEmpty) {
      return conversations[0];
    }
    return null;
  }
  List<User> getFavorites() {
    List<User> favorites = List<User>();
    favorites.addAll(users);
    return favorites;
  }
  List<Message> getMessages() {
    List<Message> cloneMessages = List<Message>();
    cloneMessages.addAll(messages);
    return cloneMessages; 
  }
  List<Message> getRecentlyMessages() {
    List<Message> cloneMessages = List<Message>();
    cloneMessages.addAll(recentlyMessages);
    return cloneMessages;
  }

  void printAll() {
    for (int i = 0; i < messages.length; i++) {
      print(messages[i]);
    }
    for (int i = 0; i < conversations.length; i++) {
      print(conversations[i]);
    }
    for (int i = 0; i < users.length; i++) {
      print(users);
    }
  }
  void addMessage(Message message) {
    //Update list of messages;
    ++maxMid;
    message.mid = "mid" + maxMid.toString();
    if (message.type == MessageType.text) {
      (message as TextMessage).text = convertToEmojiString(maxMid.toString() + " " + (message as TextMessage).text);
    }
    messages.add(message);
    bool foundCid = false;
    for (int i = 0; i < recentlyMessages.length; i++) {
      if (recentlyMessages[i].cid == message.cid) {
        if (message.sentTime.compareTo(recentlyMessages[i].sentTime) == 1) {
          recentlyMessages[i] = message;
        }
        foundCid = true;
      }
    }
    if (!foundCid) {
      recentlyMessages.add(message);
    }
  }
  ImageProvider getProvider(int i) {
    if (imageProviders == null) {
      print("Using null pointer");
      return null;
    }
    if (imageProviders.length <= i) {
      print("No provider exists");
      return null;
    }
    if (i >= imageProviders.length) {
      print("No index exists");
      return null;
    }
    return imageProviders[i];
  }
}

FakeDatabase _fakeDatabase() {
  FakeDatabase db = new FakeDatabase();
  String avatar0 = "https://travelgear.vn/blog/wp-content/uploads/2019/04/vuon-quoc-gia-bach-ma.jpg";
  String avatar1 = "https://www.dalattrip.com/dulich/media/2012/09/Cat-Tien-National-Park.jpg";
  String avatar2 = "https://i.pinimg.com/originals/ca/3e/f1/ca3ef17fb962046f986ec9931a736e05.jpg";
  String avatar3 = "https://a.wattpad.com/cover/112172874-288-k300234.jpg";
  String avatar4 = "https://i.pinimg.com/originals/41/68/d0/4168d07d150eeb2e029cff19cacb770c.jpg";
  String avatar5 = "https://www.dalattrip.com/dulich/media/2012/09/Cat-Tien-National-Park.jpg";

  String name0 = "Name 0";
  String name1 = "Name 1";
  String name2 = "Name 2";
  String name3 = "Name 3";
  String name4 = "Name 4";
  String name5 = "Name 5";
  db.imageProviders.add(NetworkImage(avatar0));
  db.imageProviders.add(NetworkImage(avatar1));
  db.imageProviders.add(NetworkImage(avatar2));
  db.imageProviders.add(NetworkImage(avatar3));
  db.imageProviders.add(NetworkImage(avatar4));
  db.imageProviders.add(NetworkImage(avatar5));
  
  db.users.add(User("uid0", name0, db.getProvider(0)));
  db.users.add(User("uid1", name1, db.getProvider(1)));
  db.users.add(User("uid2", name2, db.getProvider(2)));
  db.users.add(User("uid3", name3, db.getProvider(3)));
  db.users.add(User("uid4", name4, db.getProvider(4)));
  db.users.add(User("uid5", name5, db.getProvider(5)));

  String smallContent = loremIpsum(paragraphs: 1, words: 4) + " :)";
  String mediumContent = loremIpsum(paragraphs: 1, words: 10) + " :(";
  String bigContent = loremIpsum(paragraphs: 2, words: 30);
  DateTime d2 = DateTime.utc(2020, 2, 1);
  DateTime d3 = DateTime.utc(2020, 3, 2);
  DateTime d4 = DateTime.utc(2020, 4, 12);
  DateTime d5 = DateTime.utc(2020, 5, 12);

  db.addMessage(TextMessage("uid1", "cid0", name1, db.getProvider(1), d2, true, smallContent));
  db.addMessage(DocumentMessage("uid1", "cid0", name1, db.getProvider(1), d2, true, "small", "small"));
  db.addMessage(TextMessage("uid2", "cid0", name2, db.getProvider(2), d2, true, smallContent));
  db.addMessage(ImageMessage("uid0", "cid0", name0, db.getProvider(0), DateTime.now(), true, "https://picsum.photos/250?image=9"));
  db.addMessage(ImageMessage("uid1", "cid0", name1, db.getProvider(0), DateTime.now(), true, "https://picsum.photos/250?image=9"));
  db.addMessage(ImageMessage("uid1", "cid0", name1, db.getProvider(0), DateTime.now(), true, "https://media1.giphy.com/media/3o7TKtQGIiZ6NkRCNi/giphy.gif?cid=538c7224q06k4h2lrablsjkv5oltaty7od1mxuyl7s7p06y9&rid=giphy.gif"));
  db.addMessage(ImageMessage("uid0", "cid0", name0, db.getProvider(0), DateTime.now(), true, "https://media1.giphy.com/media/3o7TKtQGIiZ6NkRCNi/giphy.gif?cid=538c7224q06k4h2lrablsjkv5oltaty7od1mxuyl7s7p06y9&rid=giphy.gif"));

  // db.addMessage(TextMessage("uid1", "cid0", name1, db.getProvider(1), d2, true, smallContent));
  // db.addMessage(TextMessage("uid2", "cid0", name2, db.getProvider(2), d4, true, bigContent));
  // db.addMessage(TextMessage("uid2", "cid0", name2, db.getProvider(2), d4, true, bigContent));
  // db.addMessage(TextMessage("uid2", "cid0", name2, db.getProvider(2), d4, true, bigContent));
  // db.addMessage(TextMessage("uid0", "cid0", name0, db.getProvider(0), d5, true, mediumContent));
  // db.addMessage(TextMessage("uid0", "cid0", name0, db.getProvider(0), d5, true, mediumContent));
  // db.addMessage(TextMessage("uid0", "cid0", name0, db.getProvider(0), d5, true, bigContent));
  // db.addMessage(TextMessage("uid0", "cid0", name0, db.getProvider(0), DateTime.now(), true, smallContent));
  // db.addMessage(TextMessage("uid0", "cid0", name0, db.getProvider(0), DateTime.now(), true, smallContent));
  // db.addMessage(TextMessage("uid0", "cid0", name0, db.getProvider(0), DateTime.now(), true, smallContent));
  // db.addMessage(ImageMessage("uid0", "cid0", name0, db.getProvider(0), DateTime.now(), true, "https://picsum.photos/250?image=9"));

  db.addMessage(TextMessage("uid0", "cid1", name0, db.getProvider(0), DateTime.now(), true, smallContent));
  db.addMessage(TextMessage("uid1", "cid1", name1, db.getProvider(1), d2, true, smallContent));
  db.addMessage(TextMessage("uid2", "cid1", name2, db.getProvider(2), d4, true, bigContent));
  db.addMessage(TextMessage("uid0", "cid1", name0, db.getProvider(0), d5, true, bigContent));
  db.addMessage(TextMessage("uid2", "cid1", name2, db.getProvider(2), d5, true, bigContent));
  db.addMessage(TextMessage("uid2", "cid1", name2, db.getProvider(2), DateTime.now(), true, smallContent));

  db.addMessage(TextMessage("uid2", "cid2", name2, db.getProvider(2), d2, true, smallContent));
  db.addMessage(TextMessage("uid2", "cid2", name2, db.getProvider(2), d4, true, bigContent));
  db.addMessage(TextMessage("uid0", "cid2", name0, db.getProvider(0), d5, true, bigContent));
  db.addMessage(TextMessage("uid0", "cid2", name0, db.getProvider(0), DateTime.now(), true, smallContent));
  db.addMessage(TextMessage("uid1", "cid2", name1, db.getProvider(1), d2, true, smallContent));
  db.addMessage(TextMessage("uid0", "cid2", name0, db.getProvider(0), d5, true, bigContent));
  db.addMessage(TextMessage("uid0", "cid2", name0, db.getProvider(0), DateTime.now(), true, smallContent));
  db.addMessage(TextMessage("uid2", "cid2", name2, db.getProvider(2), d4, true, bigContent));
  db.addMessage(TextMessage("uid0", "cid2", name0, db.getProvider(0), d5, true, bigContent));
  db.addMessage(TextMessage("uid0", "cid2", name0, db.getProvider(0), DateTime.now(), true, smallContent));


  db.conversations.add(Conversation("cid0", "Conversation 0", db.getProvider(3)));
  db.conversations.add(Conversation("cid1", "Conversation 1", db.getProvider(4)));
  db.conversations.add(Conversation("cid2", "Conversation 2", db.getProvider(5)));


  return db;

}

FakeDatabase fakeDatabase = _fakeDatabase();