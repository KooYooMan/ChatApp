import 'package:ChatApp/src/models/conversation/conversation.dart';
import 'package:ChatApp/src/screens/conversation_screens/conversation_screen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ChatApp/src/models/message/message.dart';
import 'package:ChatApp/src/screens/fake_data/fake_database.dart';

import 'package:get_it/get_it.dart';
import 'package:ChatApp/src/services/message_service.dart';

class RecentChats extends StatefulWidget {
  final String uid;
  RecentChats(this.uid);
  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  MessageService _messageService = GetIt.I.get<MessageService>();
  List<Conversation> _conversations = [];
  Message recentMessage = null;

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: Container(
            child: StreamBuilder(
              stream: _messageService.getRecentConversations(widget.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData){
                  Map data = snapshot.data.snapshot.value;

                  if (data == null)
                    return Container();

                  _conversations.clear();
                  data.forEach((key, value) {
                    _conversations.add(Conversation.fromSnapshot(value));
                  });

                  _conversations.sort((Conversation a, Conversation b) => (a.lastTimestamp - b.lastTimestamp));
                  _conversations.forEach((element) {
                    print(element.recentMessage.seen);
                  });

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Conversation conversation = _conversations[index];
                      recentMessage = conversation.recentMessage;

                      print(recentMessage.seen[widget.uid]);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            recentMessage = Message(widget.uid,
                                DateTime.fromMillisecondsSinceEpoch(conversation.lastTimestamp),
                                conversation.recentMessage.content,
                                conversation.recentMessage.seen);
                            recentMessage.seen[widget.uid] = true;
                          });
                          _messageService.seenConversation(conversation, widget.uid);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    ConversationScreen(conversation)
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 5.0, bottom: 5.0, right: 10.0
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFEFEE),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 25.0,
                                        backgroundImage: conversation
                                            .avatarProvider,
                                      ),
                                      Positioned(
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: new DotsIndicator(
                                            dotsCount: 1,
                                            position: 0,
                                            decorator: DotsDecorator(
                                              activeColor: Colors.green,
                                              shape: const Border(),
                                              activeShape:
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      5.0)),
                                            ),
                                          ))
                                    ],
                                  ),
                                  SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        conversation.displayName,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize:
                                          recentMessage.seen[widget.uid] ? 15.0 : 16.0,
                                          fontWeight: recentMessage.seen[widget.uid]
                                              ? FontWeight.normal
                                              : FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.45,
                                        child: Text(recentMessage.toString(),
                                            style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize:
                                              recentMessage.seen[widget.uid] ? 15.0 : 16.0,
                                              fontWeight: recentMessage.seen[widget.uid]
                                                  ? FontWeight.normal
                                                  : FontWeight.bold,
                                            ),
                                            overflow:
                                            TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    DateFormat('hh:mm').format(recentMessage.sentTime),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize:
                                      recentMessage.seen[widget.uid] ? 15.0 : 16.0,
                                      fontWeight: recentMessage.seen[widget.uid]
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                else {
                  return Container();
                }
              },
            ),
          )
      ),
    ));
  }
}
