import 'package:flutter/material.dart';
import 'message.dart';

class ImageMessage extends Message {
  String imageURL;
  ImageProvider imageProvider;
  ImageMessage(String uid, String cid, String userDisplayName, ImageProvider avatarProvider, DateTime sentTime, bool seen, String imageURL)
  : super(uid, cid, userDisplayName, avatarProvider, sentTime, seen, MessageType.image) {
    this.imageURL = imageURL;
    imageProvider = NetworkImage(this.imageURL);
  }
  @override
  String getContent() {
    return this.imageURL;
  }
}