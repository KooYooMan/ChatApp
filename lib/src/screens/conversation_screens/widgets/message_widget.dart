import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ChatApp/src/models/message/message.dart';

class MessageWidget extends StatelessWidget {
  MessageWidget(this.message, this.uid);
  Message message;
  String uid;
  @override
  Widget build(BuildContext context) {
    if (uid == message.uid) {
      return Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  child: Text(
                    message.content.text,
                    style: TextStyle(color: Colors.black),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.only(right: 10.0),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    DateFormat('dd MMM kk:mm').format(message.sentTime),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal
                    ),
                  ),
                  margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            )
          ],
        )
      );
    } else {
      return Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  child: Text(
                    message.content.text,
                    style: TextStyle(color: Colors.black),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.only(right: 10.0),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    DateFormat('dd MMM kk:mm').format(message.sentTime),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal
                    ),
                  ),
                  margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            )
          ],
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }
}
