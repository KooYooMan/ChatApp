import 'package:flutter/material.dart';

import 'message.dart';

class DocumentMessage extends Message {
  String documentName;
  String documentURL;
  DocumentMessage(String uid, String cid, String userDisplayName, ImageProvider avatarProvider, DateTime sentTime, bool seen, String documentName, String documentURL)
      : super(uid, cid, userDisplayName, avatarProvider, sentTime, seen, MessageType.document) {
    this.documentURL = documentURL;
    this.documentName = documentName;
  }
  @override
  String getContent() {
    return this.documentURL;
  }
}