import 'package:ChatApp/src/models/conversation/conversation.dart';
import 'package:ChatApp/src/models/user/user.dart';
import 'package:ChatApp/src/screens/conversation_screens/conversation_screen.dart';
import 'package:ChatApp/src/screens/fake_data/fake_database.dart';
import 'package:ChatApp/src/services/auth_service.dart';
import 'package:ChatApp/src/services/message_service.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:get_it/get_it.dart';

class OnlineList extends StatefulWidget {
  @override
  _OnlineListState createState() => _OnlineListState();
}

class _OnlineListState extends State<OnlineList> {
  AuthService _authService = GetIt.I.get<AuthService>();
  MessageService _messageService = GetIt.I.get<MessageService>();
  List<User> onlineList = new List<User>();
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    _authService.getAllUsers().then((result){
      onlineList = [];
      result.forEach((element) {
        if (element.isOnline)
          onlineList.add(element);
      });
    });

    print(onlineList.length);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: ClipRRect(
        child: ListView.builder(
          itemCount: onlineList.length,
          itemBuilder: (BuildContext context, int index) {
            return FlatButton(
              onPressed: () async {
                Conversation newConversation = await _messageService.addConversation(await _authService.getCurrentDartUser(), onlineList[index]);
                newConversation.loadAvatar();
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => Material(
                    child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        body: Container(
                          child: ConversationScreen(newConversation),
                        )
                    ),
                  ),
                ));
              },
              child: Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 25.0,
                              backgroundImage: onlineList[index].avatarProvider,
                            ),
                            Positioned(
                                right: -3.0,
                                bottom: -3.0,
                                child: new DotsIndicator(
                                  dotsCount: 1,
                                  position: 0,
                                  decorator: DotsDecorator(
                                    activeColor: Colors
                                        .lightBlueAccent,
                                    shape: const Border(),
                                    activeShape:
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            5.0)),
                                  ),
                                ))
                          ]
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                onlineList[index].displayName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
