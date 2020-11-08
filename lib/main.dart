import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ChatApp/src/screens/main_screen/MainScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.pink,
      ),
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
