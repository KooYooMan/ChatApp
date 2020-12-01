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
        ),
        child: ClipRRect(
          child: Container(
            child: StreamBuilder(
              stream: _messageService.getRecentConversations(widget.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map data = snapshot.data.snapshot.value;

                  if (data == null)
                    return Container();

                  _conversations.clear();
                  data.forEach((key, value) {
                    _conversations.add(Conversation.fromSnapshot(value));
                  });

                  _conversations.sort((Conversation a, Conversation b) => (b.lastTimestamp - a.lastTimestamp));
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Conversation conversation = _conversations[index];
                      recentMessage = conversation.recentMessage;
                      print(conversation.isPrivate);

                      print("recent Message = " + recentMessage.toString());
                      String recentMessageString = recentMessage.toString();
                      String shortMessage = recentMessageString;
                      for (int i = 0; i < recentMessageString.length; i++) {
                        if (recentMessageString[i] == '\n') {
                          shortMessage = recentMessageString.substring(0, i);
                          break;
                        }
                      }

                      if (conversation.lastTimestamp < 0)
                        return Container();

                      return FlatButton(
                        onPressed: () {
                          setState(() {
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
                            top: 5.0, bottom: 5.0, right: 10.0),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
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
                                        backgroundImage: conversation.avatarProvider,
                                      ),
                                      Positioned(
                                        right: -3.0,
                                        bottom: 03.0,
                                        child: new DotsIndicator(
                                          dotsCount: 1,
                                          position: 0,
                                          decorator: DotsDecorator(
                                            activeColor: Colors.lightBlueAccent,
                                            shape: const Border(),
                                            activeShape:
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                BorderRadius
                                                  .circular(5.0)
                                            ),
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
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.45,
                                        child: Text(shortMessage,
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize:
                                              recentMessage.seen[widget.uid] ? 15.0 : 16.0,
                                              fontWeight: recentMessage.seen[widget.uid]
                                                ? FontWeight.normal
                                                : FontWeight.bold,
                                          ),
                                          overflow:
                                            TextOverflow.ellipsis
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    DateFormat('hh:mm a').format(recentMessage.sentTime),
                                    style: TextStyle(
                                      fontSize: 13.0,
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
                else{
                  if (_conversations.isEmpty)
                    return Container();
                }
                return Container();
              }
            )
          )
        )
      )
    );
  }
}
