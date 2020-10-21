import 'package:ChatApp/src/models/user/user.dart';
import 'package:ChatApp/src/screens/fake_data/fake_database.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class FavoriteContacts extends StatefulWidget {
  @override
  _FavoriteContactsState createState() => _FavoriteContactsState();
}

class _FavoriteContactsState extends State<FavoriteContacts> {
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Favorite Contacts',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 95.0,
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
                                      SizedBox(height: 6.0),
                                      Text(
                                        snapshot.data[index].displayName,
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
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
                }),
          ),
        ],
      ),
    );
  }
}
