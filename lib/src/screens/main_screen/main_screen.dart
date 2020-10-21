import 'package:ChatApp/src/screens/main_screen/new_conversation.dart';
import 'package:ChatApp/src/screens/main_screen/info.dart';
import 'package:ChatApp/src/screens/main_screen/widgets/category_select.dart';
import 'package:ChatApp/src/screens/main_screen/widgets/favorite_contacts.dart';
import 'package:ChatApp/src/screens/main_screen/widgets/online_list.dart';
import 'package:ChatApp/src/screens/main_screen/widgets/recently_chat.dart';
import 'package:flutter/material.dart';

import 'widgets/custom_search_delegate.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _idScreen = 0;
  void _changeScreen(int newId) {
    setState(() {
      _idScreen = newId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Info(),
              ),
            ),
            child: CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage("assets/images/avatar.jpg"),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          CategorySelector(
            onChanged: _changeScreen,
          ),
          Expanded(
            child: (_idScreen == 0
                ? Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            FavoriteContacts(),
                            RecentChats(),
                          ],
                        ),
                      ),
                      Positioned(
                          right: 20.0,
                          bottom: 20.0,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NewConversation(),
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundImage:
                                  AssetImage("assets/images/plus.png"),
                            ),
                          ))
                    ],
                  )
                : Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        child: OnlineList(),
                      )
                    ],
                  )),
          ),
        ],
      ),
    );
  }
}
