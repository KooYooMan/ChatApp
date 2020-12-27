import 'package:ChatApp/src/screens/auth_screens/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ChatApp/src/screens/main_screen/main_screen.dart';
import 'package:get_it/get_it.dart';

import 'package:ChatApp/src/services/firebase.dart';
import 'package:ChatApp/src/services/auth_service.dart';
import 'package:ChatApp/src/services/message_service.dart';
import 'package:ChatApp/src/services/storage_service.dart';
import 'package:ChatApp/src/services/call_service.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_map_location_picker/generated/l10n.dart'
    as location_picker;
import 'package:flutter_localizations/flutter_localizations.dart';

GetIt locator = GetIt.instance;

void setupSingletons() async {
  locator.registerLazySingleton(() => FirebaseService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => MessageService());
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => CallService());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  setupSingletons();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AuthService _authService = GetIt.I.get<AuthService>();
  String uid = "";

  @override
  Widget build(BuildContext context) {
    uid = _authService.getCurrentUID();
    // _authService.getCurrentUser().updateProfile(displayName: "dangquanghuy107@gmail.com");
    // _authService.getCurrentUser().reload();

    return MaterialApp(
      title: 'Chat App',
      localizationsDelegates: const [
        location_picker.S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en', ''),
        Locale('vn', ''),
      ],
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: (uid == null)
          ? Material(
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Container(child: AuthScreen())),
            )
          : MainScreen(),
    );
  }
}
