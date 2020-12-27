import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ChatApp/src/screens/auth_screens/constants/constants.dart';
import 'package:ChatApp/src/screens/auth_screens/ui/signin.dart';
import 'package:ChatApp/src/screens/auth_screens/ui/signup.dart';
import 'package:ChatApp/src/screens/auth_screens/ui/splashscreen.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login",
      theme: ThemeData(primaryColor: Colors.white),
      routes: <String, WidgetBuilder>{
        SPLASH_SCREEN: (BuildContext context) => SplashScreen(),
        SIGN_IN: (BuildContext context) => SignInPage(),
        SIGN_UP: (BuildContext context) => SignUpScreen(),
      },
      initialRoute: SPLASH_SCREEN,
    );
  }
}
