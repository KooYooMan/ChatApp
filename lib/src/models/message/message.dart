import 'content.dart';

class Message {
  String uid; //user ID
  String cid; //conversation ID
  Content content;
  DateTime sentTime;
  Message(String uid, String cid, DateTime sentTime, Content content) {
    this.uid = uid;
    this.cid = cid;
    this.sentTime = sentTime;
    this.content = content;
  }
}
