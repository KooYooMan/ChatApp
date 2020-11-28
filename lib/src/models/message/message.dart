enum MessageType {
  text,
  document,
  image,
  audio,
}

class Message {
  String sender;
  DateTime sentTime;
  Map seen;
  MessageType type;
  String content;

  Message(String sender, DateTime sentTime, Map seen, MessageType messageType, String content) {
    this.sender = sender;
    this.sentTime = sentTime;
    this.seen = seen;
    this.type = messageType;
    this.content = content;
  }

  Message.fromSnapshot(String mid, Map data){
    this.sender = data['sender'];
    this.sentTime = DateTime.fromMillisecondsSinceEpoch(int.parse(mid));
    this.seen = data['seen'];
    this.type = MessageType.values[data['type']];
    this.content = data['content'];
  }
}