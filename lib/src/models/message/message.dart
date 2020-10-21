class Message {
  String uid; //user ID
  String cid; //conversation ID
  Content content;
  Message({this.uid, this.cid, this.content});
}

class Content {
  String text;
  Content({this.text});
}