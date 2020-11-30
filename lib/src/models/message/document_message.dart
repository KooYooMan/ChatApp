import 'message.dart';

class DocumentMessage extends Message {
  String documentName;

  DocumentMessage(String uid, DateTime sentTime, Map seen, String documentName, String documentURL)
      : super(uid, sentTime, seen, MessageType.document, documentURL) {
    this.documentName = documentName;
  }

  DocumentMessage.fromSnapshot(String mid, Map data): super.fromSnapshot(mid, data) {
    this.documentName = data['docName'];
  }

  @override
  String toString() {
    return "File";
  }
}