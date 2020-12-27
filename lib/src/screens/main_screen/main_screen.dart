import 'dart:convert';

import 'package:ChatApp/src/screens/main_screen/new_contact_screen.dart';
import 'package:ChatApp/src/screens/main_screen/new_conversation_screen.dart';
import 'package:ChatApp/src/screens/main_screen/info.dart';
import 'package:ChatApp/src/screens/main_screen/widgets/category_select.dart';
import 'package:ChatApp/src/screens/main_screen/widgets/recently_contacts.dart';
import 'package:ChatApp/src/screens/main_screen/widgets/online_list.dart';
import 'package:ChatApp/src/screens/main_screen/widgets/recently_chat.dart';
import 'package:ChatApp/src/services/auth_service.dart';
import 'package:ChatApp/src/services/firebase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  User currentUser;
  AuthService _authService = GetIt.I.get<AuthService>();
  FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

  int _idScreen = 0;
  void _changeScreen(int newId) {
    setState(() {
      _idScreen = newId;
    });
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      var ref = _firebaseService.getDatabaseReference(["users", currentUser.uid]);
      _firebaseService.updateDocument(ref, Map<String, dynamic>.from({
        'pushToken': token
      }));
    }).catchError((err) {
      print('error = ${err.message.toString()}');
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings =
        new InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'com.dfa.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);

    print(message);

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  @override
  void initState() {
    super.initState();
    currentUser = _authService.getCurrentUser();
    var ref = _firebaseService.getDatabaseReference(["users", currentUser.uid]);
    ref.update({
      "isOnline": true
    });
    registerNotification();
    configLocalNotification();
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = _authService.getCurrentUser();
    final List<String> titles = ['Recently Chats', 'Online Contacts', 'Group'];

    var ref = _firebaseService.getDatabaseReference(["users", currentUser.uid]);
    var onlineRef = _firebaseService.getDatabaseReference([".info/connected"]);
    onlineRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.value == true) {
        ref.update({"isOnline": true});
        print('Client is Connected');
      }
    });

    ref.onDisconnect().update({"isOnline": false});

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          margin: EdgeInsets.only(top: 5.0, left: 10.0, bottom: 5.0),
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
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            width: 45.0,
            height: 45.0,
            child: IconButton(
              icon: Icon(Icons.person_search),
              iconSize: 25.0,
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
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            width: 45.0,
            height: 45.0,
            child: IconButton(
              icon: Icon(Icons.group_add_outlined),
              iconSize: 25.0,
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NewConversationScreen()),
                );
              },
            ),
          ),
        ],
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
                        RecentlyContacts(currentUser.uid),
                        RecentChats(currentUser.uid),
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
          )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Online',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Group',
          ),
        ],
        currentIndex: _idScreen,
        selectedItemColor: Colors.amber[800],
        onTap: _changeScreen,
      ),
    );
  }
}
