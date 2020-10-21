import 'dart:async';

import 'package:ChatApp/src/models/message/content.dart';
import 'package:ChatApp/src/models/message/message.dart';
import 'package:ChatApp/src/models/conversation/conversation.dart';
import 'package:ChatApp/src/screens/conversation_screens/widgets/circular_image.dart';
import 'package:ChatApp/src/screens/conversation_screens/widgets/message_widget.dart';
import 'package:ChatApp/src/screens/conversation_screens/widgets/name_widget.dart';
import 'package:ChatApp/src/screens/conversation_screens/widgets/time_stamp_widget.dart';
import 'package:ChatApp/src/screens/fake_data/fake_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



class ConversationScreen extends StatefulWidget {
  final String uid;
  final Conversation conversation;
  final Stream<Message> messageStream;
  ConversationScreen(this.uid, this.conversation, this.messageStream);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}


class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _textEditingController = new TextEditingController();
  // ignore: close_sinks
  final StreamController<Message> messageStreamController = new StreamController();

  ScrollController _messageListScrollController = ScrollController();

  Widget conversationAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.keyboard_backspace),
        iconSize: 30.0,
        color: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Row(
        children: [
          CircularImage(widget.conversation.avatarProvider),
          SizedBox(width: 8.0),
          Container(
            child: Text(
              widget.conversation.displayName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]
      ),
      elevation: 0.0,
      actions: [
        IconButton(
          icon: Icon(Icons.call),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.info),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {},
        )
      ],
      backgroundColor: Colors.red,
    );
  }


  Widget inputWidget() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 8,),
              Flexible(
                child: Container(
                  child: TextField(
                    style: TextStyle(color: Colors.grey, fontSize: 15.0),
                    controller: _textEditingController,
                    decoration: InputDecoration.collapsed(
                      hintText: "Viết tin nhắn",
                    ),
                  ),
                ),
              ),
              Material(
                child: new Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    icon: new Icon(Icons.send),
                    color: Colors.grey,
                    //TODO: do actually onPressed function
                    onPressed: () => {
                      //TODO: send message to
                      _textEditingController.clear()
                    },
                  )
                )
              )
            ],
          ),
          Row(
            //TODO: do option for gif, icon, ...
            children: [
              Material(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  child: new IconButton(
                    icon: Icon(Icons.face),
                    color: Colors.black,
                    //TODO: do actually onPress
                    onPressed: () => {},
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  Widget messageListWidget() {
    return StreamBuilder(
      stream: widget.messageStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          widget.conversation.addMessage(snapshot.data);
        }
        return Expanded(
          child: ListView.builder(
            controller: _messageListScrollController,
            itemCount: widget.conversation.messageList.length,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (context, index) {
              int length = widget.conversation.messageList.length;
              int currIdx = length - index - 1;
              bool isSentByMe = widget.uid == widget.conversation.messageList[currIdx].uid;
              Message currMess = widget.conversation.messageList[currIdx];
              int nextIdx = currIdx + 1;
              Widget w;
              bool showName = false;
              bool showTime = false;

              if (((nextIdx < length && widget.conversation.messageList[nextIdx].uid != currMess.uid) || nextIdx >= length)) {
                if (isSentByMe) {
                  w = Column(
                    children: [
                      MessageWidget(widget.conversation.messageList[currIdx], isSentByMe),
                      SizedBox(height: 5.0,),
                    ],
                  );
                } else {
                  w = Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10.0,),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CircularImage(currMess.avatarProvider)
                          ),
                          MessageWidget(currMess, isSentByMe),
                        ],
                      ),
                      SizedBox(height: 5.0,)
                    ]
                  );
                }
              } else {
                if (isSentByMe) {
                  w = MessageWidget(widget.conversation.messageList[currIdx], isSentByMe);
                } else {
                  w = Row(
                    children: [
                      SizedBox(width: 40.0),
                      MessageWidget(currMess, isSentByMe)
                    ],
                  );
                }
              }
              int prevIdx = currIdx - 1;
              if ((prevIdx >= 0 && currMess.sentTime.difference(widget.conversation.messageList[prevIdx].sentTime).inMinutes >= 15) || prevIdx < 0) {
                showTime = true;

              }
              if ((prevIdx >= 0 && widget.conversation.messageList[prevIdx].uid != currMess.uid) || prevIdx < 0) {
                showName = true;
              } else {
                showName = showTime;
              }
              if (showName && !isSentByMe) {
                w = Column(
                  children: [
                    NameWidget(currMess.userDisplayName),
                    w
                  ],
                );
              }
              print("text = " + currMess.content.text + " showtime = " + (showTime ? "true" : "false") + " uid = " + currMess.uid + " name = " + currMess.userDisplayName);
              if (showTime) {
                w = Column(
                  children: [
                    TimeStampWidget(currMess.sentTime),
                    SizedBox(height: 10.0),
                    w
                  ],
                );
              }
              return w;
            }
          ),
        );
      }
    );

  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: conversationAppBar(),
        body: Column(
          children: [
            messageListWidget(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: inputWidget(),
            )
          ],
        )
      )
    );
  }
}

ConversationScreen fakeConversationScreen(String cid) {
  Conversation fakeConversation = fakeDatabase.getConversationByCid(cid);
  ConversationScreen conversationScreen = ConversationScreen("uid0", fakeConversation, fakeDatabase.getMessageStreamByCid(fakeConversation.cid));
  return conversationScreen;
}

