import 'package:flutter/material.dart';
import 'message.dart';

class ImageMessage extends Message {
  ImageProvider imageProvider;
  ImageMessage(String uid, DateTime sentTime, Map seen, String imageURL)
  : super(uid, sentTime, seen, MessageType.image, imageURL) {
    imageProvider = NetworkImage(imageURL);
  }

  ImageMessage.fromSnapshot(String mid, Map data): super.fromSnapshot(mid, data) {
    imageProvider = NetworkImage(data['content']);
  }

  @override
  String toString() {
    return "Image📷📷📷";
  }
}