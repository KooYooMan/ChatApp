class Message {
  String uid; //user ID
  String cid; //conversation ID
  String time;
  Content content;
  bool seen;
  Message({this.uid, this.cid, this.time, this.content, this.seen});
}

class Content {
  String text;
  Content({this.text});
}
