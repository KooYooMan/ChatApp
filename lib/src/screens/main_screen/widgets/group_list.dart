import 'package:ChatApp/src/models/conversation/conversation.dart';
import 'package:ChatApp/src/screens/conversation_screens/conversation_screen.dart';
import 'package:ChatApp/src/services/auth_service.dart';
import 'package:ChatApp/src/services/firebase.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ChatApp/src/models/message/message.dart';
import 'package:ChatApp/src/screens/fake_data/fake_database.dart';

import 'package:get_it/get_it.dart';
import 'package:ChatApp/src/services/message_service.dart';

class GroupList extends StatefulWidget {
  final String uid;
  GroupList(this.uid);
  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  MessageService _messageService = GetIt.I.get<MessageService>();
  FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  AuthService _authService = GetIt.I.get<AuthService>();
  List<Conversation> _conversations = [];
  Message recentMessage = null;
  Map <String, NetworkImage> avatar = new Map<String, NetworkImage>();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ClipRRect(
                child: Container(
                    child: StreamBuilder(
                        stream:
                        _messageService.getRecentConversations(widget.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Map data = snapshot.data.snapshot.value;

                            if (data == null) return Container();

                            _conversations.clear();
                            data.forEach((key, value) {
                              var conversationInstance = Conversation.fromSnapshot(key, value);
                              conversationInstance.loadAvatar();
                              if (conversationInstance.users.length > 2)
                                _conversations
                                    .add(conversationInstance);
                            });

                            // _conversations.forEach((element) {
                            //   element.loadAvatar();
                            // });
                            // for (var i = 0; i < _conversations.length; i++)
                            //   _conversations[i].loadAvatar();


                            _conversations.sort(
                                    (Conversation a, Conversation b) =>
                                (b.lastTimestamp - a.lastTimestamp));
                            return ListView.builder(
                              itemCount: _conversations.length,
                              itemBuilder: (BuildContext context, int index) {
                                Conversation conversation =
                                _conversations[index];
                                recentMessage = conversation.recentMessage;
                                var conversationAvatar;
                                if (conversation.users.length == 1){
                                  conversationAvatar = avatar[widget.uid];
                                }
                                if (conversation.users.length == 2){
                                  conversation.users.forEach((element) {
                                    if (element != widget.uid)
                                      conversationAvatar = avatar[element];
                                  });
                                }
                                if (conversation.users.length > 2){
                                  conversationAvatar = NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUaaCmVssmaJOUN81ME-8C0PlRJuAbY_oDOA&usqp=CAU");
                                }

                                String recentMessageString =
                                recentMessage.toString();
                                String shortMessage = recentMessageString;
                                for (int i = 0;
                                i < recentMessageString.length;
                                i++) {
                                  if (recentMessageString[i] == '\n') {
                                    shortMessage =
                                        recentMessageString.substring(0, i);
                                    break;
                                  }
                                }

                                if (conversation.lastTimestamp < 0)
                                  return Container();

                                return FlatButton(
                                  onPressed: () {
                                    setState(() {
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              ConversationScreen(conversation)),
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
                                                  backgroundImage: conversationAvatar,
                                                ),
                                                // Positioned(
                                                //     right: -3.0,
                                                //     bottom: -3.0,
                                                //     child: new DotsIndicator(
                                                //       dotsCount: 1,
                                                //       position: 0,
                                                //       decorator: DotsDecorator(
                                                //         activeColor: Colors
                                                //             .lightBlueAccent,
                                                //         shape: const Border(),
                                                //         activeShape:
                                                //             RoundedRectangleBorder(
                                                //                 borderRadius:
                                                //                     BorderRadius
                                                //                         .circular(
                                                //                             5.0)),
                                                //       ),
                                                //     ))
                                              ],
                                            ),
                                            SizedBox(width: 10.0),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.45,
                                                  child: Text(
                                                      conversation.displayName,
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                      ),
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                                SizedBox(height: 5.0),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.45,
                                                  child: Text(shortMessage,
                                                      style: TextStyle(
                                                          color: Colors.blueGrey,
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.normal
                                                      ),
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              DateFormat('hh:mm a').format(
                                                  recentMessage.sentTime),
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
                          } else {
                            if (_conversations.isEmpty) return Container();
                          }
                          return Container();
                        })))));
  }
}
