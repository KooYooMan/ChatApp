import 'package:ChatApp/src/models/user/user.dart';
import 'package:ChatApp/src/screens/fake_data/fake_database.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class RecentlyContacts extends StatefulWidget {
  @override
  _RecentlyContactsState createState() => _RecentlyContactsState();
}

class _RecentlyContactsState extends State<RecentlyContacts> {
  Stream<List<User>> _stream = (() async* {
    List<User> favorites = fakeDatabase.getFavorites();
    List<List<User>> listRecentlyChats = [];

    List<User> recentlyChats0 = List<User>();
    recentlyChats0.addAll(favorites);
    listRecentlyChats.add(recentlyChats0);

    List<User> recentlyChats1 = List<User>();
    recentlyChats1.addAll(favorites);
    recentlyChats1.shuffle();
    listRecentlyChats.add(recentlyChats1);

    List<User> recentlyChats2 = List<User>();
    recentlyChats2.addAll(favorites);
    recentlyChats2.shuffle();
    listRecentlyChats.add(recentlyChats2);

    for (int i = 0; i < listRecentlyChats.length; ++i) {
      yield listRecentlyChats[i];
      await Future.delayed(Duration(seconds: 3));
    }
  })();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 95.0,
          decoration: BoxDecoration(
            color: Color(0xfff5f5f5),
          ),
          child: StreamBuilder<List<User>>(
            stream: _stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Not found the fetch function'),
                    );
                    break;
                  default:
                    if (snapshot.data == null) {
                      return Container();
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.only(left: 10.0),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
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
                                        backgroundImage: snapshot.data[index].avatarProvider,
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
                                            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                          ),
                                        )
                                      ),
                                      Positioned(
                                          right: -4.0,
                                          bottom: -4.0,
                                          child: new DotsIndicator(
                                            dotsCount: 1,
                                            position: 0,
                                            decorator: DotsDecorator(
                                              activeColor: Colors.lightBlueAccent,
                                              shape: const Border(),
                                              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                            ),
                                          )
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: 6.0),
                                  Text(
                                    snapshot.data[index].displayName,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                }
              }
            }
          ),
        ),
      ],
    );
  }
}
