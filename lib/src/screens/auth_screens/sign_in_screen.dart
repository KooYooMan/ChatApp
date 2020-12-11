import 'package:ChatApp/src/screens/main_screen/main_screen.dart';
import 'package:ChatApp/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:toast/toast.dart';
import 'helpers/helpers.dart';
import 'widgets/input_fields.dart';
import 'widgets/buttons.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({this.switchPage});
  final Function() switchPage;
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKeySignIn = GlobalKey<FormState>();
  AuthService _authService = GetIt.I.get<AuthService>();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  String _email;
  String _password;
  bool _keyboardVisible = false;
  bool _isLogging = false;
  void initState() {
    // print("signInScreen");
    super.initState();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
          // print("Keyboard State hanged : $visible");
        });
      },
    );
  }

  Future<String> _signIn() async {
    if (formKeySignIn.currentState == null) return "-1";
    if (formKeySignIn.currentState.validate()) {
      _email = emailTextEditingController.text;
      _password = passwordTextEditingController.text;
      var uid = await _authService.signIn(_email, _password);
      return uid;
    }
    return "-1";
  }

  Widget _buildForm() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 7),
          child: Form(
            key: formKeySignIn,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Container(
                  margin: EdgeInsets.only(bottom: 20, left: 20.0, right: 20.0),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 27),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: InputField(
                    icon: Icons.email,
                    hint: "Enter Email...",
                    controller: emailTextEditingController,
                    formKey: formKeySignIn,
                    validator: (value) {
                      return emailValidator(value);
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: HiddenInputField(
                    icon: Icons.vpn_key,
                    hint: "Enter Password...",
                    controller: passwordTextEditingController,
                    formKey: formKeySignIn,
                    validator: (value) {
                      return passwordValidator(value, value);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            setState(() {
              _isLogging = true;
            });
            String signInResult = "-1";
            bool logError = false;
            try {
              signInResult = await _signIn();
            } catch (e) {
              logError = true;
              print(e);
            } finally {
              setState(() {
                _isLogging = false;
              });
            }
            print(_isLogging.toString());
            if (signInResult != "-1" && logError == false) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MainScreen(),
                ),
              );
            } else {
              Toast.show("Username or password is incorrect", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: PrimaryButton(
              text: "Login",
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: widget.switchPage,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: NeOutlineButton(
              text: "Create New Account",
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_isLogging.toString());
    return SafeArea(
      child: Scaffold(
        body: (_isLogging == false)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildForm(),
                  (_keyboardVisible == false)
                      ? Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: _buildButtons())
                      : Container(),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
