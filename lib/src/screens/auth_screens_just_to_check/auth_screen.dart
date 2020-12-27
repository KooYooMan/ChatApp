import 'package:ChatApp/src/screens/auth_screens_just_to_check/sign_in_screen.dart';
import 'package:ChatApp/src/screens/auth_screens_just_to_check/sign_up_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:ChatApp/src/services/auth_service.dart';
import 'package:get_it/get_it.dart';
import 'widgets/buttons.dart';
import 'widgets/input_fields.dart';
import 'helpers/helpers.dart';
import 'get_started_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Widget _authWidget = GetStartedScreen();
  Widget _signUpScreen;
  Widget _signInScreen;
  Widget _getStartedScreen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _signUpScreen = SignUpScreen(
      switchPage: () {
        setState(() {
          _authWidget = _signInScreen;
        });
      },
    );
    _signInScreen = SignInScreen(
      switchPage: () {
        setState(() {
          _authWidget = _signUpScreen;
        });
      },
    );
    _getStartedScreen = GetStartedScreen(
      switchPage: () {
        setState(() {
          _authWidget = _signInScreen;
        });
      },
    );
    _authWidget = _getStartedScreen;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) =>
          ScaleTransition(
        scale: animation,
        child: child,
      ),
      child: _authWidget,
    );
  }
}
