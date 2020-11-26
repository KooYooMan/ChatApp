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

import 'package:get_it/get_it.dart';
import 'package:ChatApp/src/services/auth_service.dart';
import 'package:ChatApp/src/services/message_service.dart';
import 'package:ChatApp/src/services/storage_service.dart';



class ConversationScreen extends StatefulWidget {
  Conversation conversation;
  ConversationScreen(this.conversation);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}


class _ConversationScreenState extends State<ConversationScreen> {
  AuthService _authService = GetIt.I.get<AuthService>();
  MessageService _messageService = GetIt.I.get<MessageService>();
  StorageService _storageService = GetIt.I.get<StorageService>();

  final TextEditingController _textEditingController = new TextEditingController();
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
          CircularImage(NetworkImage(_authService.getCurrentUser().photoURL)), //TODO: change avatar
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
                    onPressed: (){
                      String messageContent = _textEditingController.text;
                      _messageService.addMessage(widget.conversation, _authService.getCurrentUID(), messageContent);
                      _textEditingController.clear();
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
    String cid = widget.conversation.cid;

    return StreamBuilder(
      stream: _messageService.getMessages(cid),
      builder: (context, snapshot) {
        List<Message> list = [];
        if (snapshot.hasData) {
          Map data = snapshot.data.snapshot.value;
          if (data != null)
            data.forEach((key, value) {
              list.add(Message.fromSnapshot(key, value));
            });
          list.sort((Message a, Message b) => (a.sentTime.millisecondsSinceEpoch - b.sentTime.millisecondsSinceEpoch));
        }
        return Expanded(
          child: ListView.builder(
            controller: _messageListScrollController,
            itemCount: list.length,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (context, index) {
              int length = list.length;
              int currIdx = length - index - 1;
              bool isSentByMe = _authService.getCurrentUID() == list[currIdx].sender;
              Message currMess = list[currIdx];
              int nextIdx = currIdx + 1;
              Widget w;
              bool showName = false;
              bool showTime = false;

              if (((nextIdx < length && list[nextIdx].sender != currMess.sender) || nextIdx >= length)) {
                if (isSentByMe) {
                  w = Column(
                    children: [
                      MessageWidget(list[currIdx], isSentByMe),
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
                            child: CircularImage(NetworkImage(_authService.getCurrentUser().photoURL)) // TODO: avatar
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
                  w = MessageWidget(list[currIdx], isSentByMe);
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
              if ((prevIdx >= 0 && currMess.sentTime.difference(list[prevIdx].sentTime).inMinutes >= 15) || prevIdx < 0) {
                showTime = true;

              }
              if ((prevIdx >= 0 && list[prevIdx].sender != currMess.sender) || prevIdx < 0) {
                showName = true;
              } else {
                showName = showTime;
              }
              if (showName && !isSentByMe) {
                w = Column(
                  children: [
                    NameWidget(widget.conversation.displayName),
                    w
                  ],
                );
              }
              //print("text = " + currMess.content.text + " showtime = " + (showTime ? "true" : "false") + " uid = " + currMess.sender + " name = " + "TODO");
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
  ConversationScreen conversationScreen = ConversationScreen(fakeConversation);
  return conversationScreen;
}

