import 'package:flutter/material.dart';
import 'package:ChatApp/src/models/message/message.dart';

class MessageWidget extends StatefulWidget {
  MessageWidget(this.message, this.isSentByMe);
  final Message message;
  final bool isSentByMe;
  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {

  Widget contentBox() {
    Color decorationColor = (widget.isSentByMe) ? Colors.red : Colors.grey[300];
    Color textColor = (widget.isSentByMe) ? Colors.white : Colors.black;
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 3 * 2,
      ),
      child: Text(
        widget.message.content.text,
        style: TextStyle(color: textColor),
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      decoration: BoxDecoration(
        color: decorationColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if (widget.isSentByMe) {
      return Container(
        child: Row(
          children: [
            contentBox(),
            SizedBox(width: 5.0),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
        padding: EdgeInsets.only(bottom: 2.0),
      );
    } else {
      return Container(
        child: Row(
          children: [
            SizedBox(width: 5.0),
            contentBox(),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        padding: EdgeInsets.only(bottom: 2.0),
      );
    }
  }
}

