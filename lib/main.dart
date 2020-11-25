import 'package:ChatApp/src/screens/auth_screens/sign_in_screen.dart';
import 'package:ChatApp/src/screens/conversation_screens/conversation_screen.dart';
import 'package:ChatApp/src/screens/conversation_screens/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ChatApp/src/screens/main_screen/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());


}

class MyApp extends StatelessWidget {
  bool userIsLoggedIn = true;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: (userIsLoggedIn == false) ?
      Material(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            child: SignInScreen()
          )
        ),
      ) : MainScreen()
    );
  }
}
