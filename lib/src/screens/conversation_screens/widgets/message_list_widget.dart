import 'package:flutter/material.dart';
import 'package:ChatApp/src/models/message/message.dart';
import 'message_widget.dart';

class MessageListWidget extends StatelessWidget {
  MessageListWidget(this.messageList, this.uid);
  ScrollController listScrollController = new ScrollController();
  List<Message> messageList;
  String uid;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemBuilder: (BuildContext context, int index) {
          return MessageWidget(messageList[index], true);
        },
        itemCount: messageList.length,
        controller: listScrollController,
      ),
    );
  }
}



