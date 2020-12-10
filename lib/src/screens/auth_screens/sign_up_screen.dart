import 'package:ChatApp/src/screens/main_screen/main_screen.dart';
import 'package:ChatApp/src/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'helpers/helpers.dart';
import 'widgets/input_fields.dart';
import 'widgets/buttons.dart';
import 'package:toast/toast.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({this.switchPage});
  final Function() switchPage;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKeySignUp = GlobalKey<FormState>();
  AuthService _authService = GetIt.I.get<AuthService>();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController usernameTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      new TextEditingController();
  String _email;
  String _username;
  String _password;
  String _confirmPassword;
  bool _keyboardVisible = false;

  void initState() {
    print("signUpScreen");
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

  bool isLoading = false;
  Future<void> _signUp() async {
    if (formKeySignUp.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _username = usernameTextEditingController.text;
      _email = emailTextEditingController.text;
      _password = passwordTextEditingController.text;


      try {
        await _authService.signUp(_email, _password, _username);
      } catch(e) {
        Toast.show("The email is already in use by another account", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return Future.error(e);
      } finally {
        setState(() {
          isLoading = false;
        });
      }

      Toast.show("Sign up successful", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      widget.switchPage();
    }
  }

  Widget _buildForm() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 7),
          child: Form(
            key: formKeySignUp,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Create a New Account",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: InputField(
                    icon: Icons.email,
                    hint: "Enter Email...",
                    controller: emailTextEditingController,
                    formKey: formKeySignUp,
                    validator: (value) {
                      return emailValidator(value);
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: InputField(
                    icon: Icons.person,
                    hint: "Enter your display name",
                    controller: usernameTextEditingController,
                    formKey: formKeySignUp,
                    validator: (value) {
                      return usernameValidator(value);
                    },
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: HiddenInputField(
                    icon: Icons.vpn_key,
                    hint: "Enter Password...",
                    controller: passwordTextEditingController,
                    formKey: formKeySignUp,
                    validator: (value) {
                      return passwordValidator(value, value);
                    },
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: HiddenInputField(
                      icon: Icons.vpn_key,
                      hint: "Confirm Password...",
                      controller: confirmPasswordTextEditingController,
                      formKey: formKeySignUp,
                      validator: (value) {
                        return passwordValidator(
                            value, passwordTextEditingController.text);
                      }),
                ),
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
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: PrimaryButton(
              text: "Create Account",
            ),
          ),
          onTap: () {
            _signUp();
          },
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: widget.switchPage,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: NeOutlineButton(
              text: "Back To Login",
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: (isLoading == true) ? Center(child: CircularProgressIndicator(),) : Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildForm(),
            (_keyboardVisible == false)
                ? Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: _buildButtons())
                : Container(),
          ],
        ),
      ),
    );
  }
}
