import 'package:ChatApp/src/models/user/user.dart';
import 'package:ChatApp/src/screens/fake_data/fake_database.dart';
import 'package:ChatApp/src/services/auth_service.dart';
import 'package:ChatApp/src/services/firebase.dart';
import 'package:ChatApp/src/services/message_service.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RecentlyContacts extends StatefulWidget {
  final String uid;
  RecentlyContacts(this.uid);
  @override
  _RecentlyContactsState createState() => _RecentlyContactsState();
}

class _RecentlyContactsState extends State<RecentlyContacts> {
  MessageService _messageService = GetIt.I.get<MessageService>();
  AuthService _authService = GetIt.I.get<AuthService>();
  FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  List<User> recentContacts = new List<User>();
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Container();
    return isLoading || recentContacts.length == 0
        ? Container()
        : Column(
            children: <Widget>[
              Container(
                  height: 95.0,
                  decoration: BoxDecoration(
                    color: Color(0xfff5f5f5),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 10.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: recentContacts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Text("Hello World!"),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 25.0,
                                    backgroundImage:
                                        recentContacts[index].avatarProvider,
                                  ),
                                  Positioned(
                                      right: -3.0,
                                      bottom: -3.0,
                                      child: new DotsIndicator(
                                        dotsCount: 1,
                                        position: 0,
                                        decorator: DotsDecorator(
                                          activeColor: Color(0xfff5f5f5),
                                          shape: const Border(),
                                          activeShape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                        ),
                                      )),
                                  Positioned(
                                      right: -4.0,
                                      bottom: -4.0,
                                      child: new DotsIndicator(
                                        dotsCount: 1,
                                        position: 0,
                                        decorator: DotsDecorator(
                                          activeColor: Colors.lightBlueAccent,
                                          shape: const Border(),
                                          activeShape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0)),
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(height: 6.0),
                              Text(
                                recentContacts[index].displayName,
                                style: TextStyle(
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
            ],
          );
  }
}
