import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/src/screens/fake_data/fake_messages.dart';
import 'package:ChatApp/src/models/message/message.dart';

class RecentChats extends StatefulWidget {
  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  Stream<List<Message>> _stream = (() async* {
    List<List<Message>> listRecentlyChats = [];

    List<Message> recentlyChats0 = List<Message>();
    recentlyChats0.addAll(chats);
    listRecentlyChats.add(recentlyChats0);

    List<Message> recentlyChats1 = List<Message>();
    recentlyChats1.addAll(chats);
    recentlyChats1.shuffle();
    listRecentlyChats.add(recentlyChats1);

    List<Message> recentlyChats2 = List<Message>();
    recentlyChats2.addAll(chats);
    recentlyChats2.shuffle();
    listRecentlyChats.add(recentlyChats2);

    for (int i = 0; i < listRecentlyChats.length; ++i) {
      yield listRecentlyChats[i];
      await Future.delayed(Duration(seconds: 3));
    }
  })();

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
          child: StreamBuilder<List<Message>>(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      )
                    ],
                  );
                } else {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info,
                            color: Colors.blue,
                            size: 60,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Not found the fetch function'),
                          )
                        ],
                      );
                      break;
                    default:
                      if (snapshot.data == null) {
                        return Container();
                      }
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Message chat = snapshot.data[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Text("Hello World!"),
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 5.0, bottom: 5.0, right: 10.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
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
                                            backgroundImage: AssetImage(
                                                './assets/images/avatar.jpg'),
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
                                            "Manh Cao",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5.0),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            child: Text(chat.content.text,
                                                style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize:
                                                      chat.seen ? 15.0 : 16.0,
                                                  fontWeight: chat.seen
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
                                        chat.time,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
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
                }
              }),
        ),
      ),
    );
  }
}
