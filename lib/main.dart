import 'package:ChatApp/src/screens/auth_screens/sign_in_screen.dart';
import 'package:ChatApp/src/screens/conversation_screens/conversation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ChatApp/src/screens/main_screen/main_screen.dart';
import 'package:get_it/get_it.dart';

import 'package:ChatApp/src/services/firebase.dart';
import 'package:ChatApp/src/services/auth_service.dart';
import 'package:ChatApp/src/services/message_service.dart';
import 'package:ChatApp/src/services/storage_service.dart';

import 'package:ChatApp/src/screens/test_firebase/test_firebase_widget.dart';
import 'package:ChatApp/src/screens/conversation_screens/conversation_screen.dart';

GetIt locator = GetIt.instance;

void setupSingletons() async {
  locator.registerLazySingleton(() => FirebaseService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => MessageService());
  locator.registerLazySingleton(() => StorageService());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupSingletons();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AuthService _authService = GetIt.I.get<AuthService>();
  StorageService _storageService = GetIt.I.get<StorageService>();
  String uid = "";
  // final user = Provider.of<User>;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    uid = _authService.getCurrentUID();
    // _authService.getCurrentUser().updateProfile(displayName: "dangquanghuy107@gmail.com");
    // _authService.getCurrentUser().reload();

    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: (uid == null) ?
      Material(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            child: SignInScreen()
          )
        ),
      ) : MainScreen()

      // home: TestFirebaseScreen(),
    );
  }
}
