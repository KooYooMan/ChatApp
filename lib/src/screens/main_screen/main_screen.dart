import 'package:ChatApp/src/screens/main_screen/new_contact_screen.dart';
import 'package:ChatApp/src/screens/main_screen/new_conversation.dart';
import 'package:ChatApp/src/screens/main_screen/info.dart';
import 'package:ChatApp/src/screens/main_screen/widgets/category_select.dart';
import 'package:ChatApp/src/screens/main_screen/widgets/recently_contacts.dart';
import 'package:ChatApp/src/screens/main_screen/widgets/online_list.dart';
import 'package:ChatApp/src/screens/main_screen/widgets/recently_chat.dart';
import 'package:ChatApp/src/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'widgets/custom_search_delegate.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AuthService _authService = GetIt.I.get<AuthService>();

  int _idScreen = 0;
  void _changeScreen(int newId) {
    setState(() {
      _idScreen = newId;
    });
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = _authService.getCurrentUser();
    final List<String> titles = ['Recently Chats', 'Online Contacts', 'Group'];

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              radius: 15.0,
              backgroundImage: NetworkImage(currentUser.photoURL),
            ),
          ),
        ),
        title: Text(titles[_idScreen],
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.black
          ),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            width: 35.0,
            height: 35.0,
            child: IconButton(
              icon: Icon(Icons.message_outlined),
              iconSize: 20.0,
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NewContactScreen()),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            width: 35.0,
            height: 35.0,
            child: IconButton(
              icon: Icon(Icons.group_add_outlined),
              iconSize: 20.0,
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NewConversation()),
                );
              },
            ),
          ),
        ],
        bottom: CategorySelector(
          onChanged: _changeScreen,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: IndexedStack(
              index: _idScreen,
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[
                          RecentlyContacts(),
                          RecentChats(_authService.getCurrentUID()),
                        ],
                      ),
                    ),
                  ],
                ),
                Stack(
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
                ),
                Container(),
              ],
            )
          ),
        ],
      ),
    );
  }
}
