import 'package:ChatApp/src/screens/main_screen/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:ChatApp/src/services/auth_service.dart';
import 'package:get_it/get_it.dart';

emailValidator(String val){
  if (val.isEmpty) return "Your email should not be empty";
  if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)) {
    return null;
  }
  return "Invalid email";
}

passwordValidator(String password, String confirmPassword) {
  if(password.isEmpty) return "Your password should not be empty";
  if(password.length < 6) return "Your password should be at 6+ characters";
  if(password != confirmPassword) return "Passwords should be the same";
  if(RegExp(r"^\d*[a-zA-Z][a-zA-Z\d]*$").hasMatch(password)) {
    return null;
  }
  else {
    return "No special characters allowed";
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  AuthService _authService = GetIt.I.get<AuthService>();

  final formKeySignIn = GlobalKey<FormState>();
  final formKeySignUp = GlobalKey<FormState>();

  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  TextEditingController confirmPasswordTextEditingController = new TextEditingController();

  String _email;
  String _password;

  String _signInError;

  int  _pageState = 0;
  var _backgroundColor = Colors.white;
  var _headingColor = Color(0xFFB40284A);
  double windowWidth = 0;
  double windowHeight = 0;

  double _headingTop = 100;

  bool _keyboardVisible = false;

  bool _keyboardVisibleOnce = false;
  bool _keyboardVisibleTwice = false;

  double _loginWidth = 0;
  double _loginHeight = 0;
  double _loginYOffset = 0;
  double _loginXOffset = 0;
  double _loginOpacity = 1;

  double _registerHeight = 0;
  double _registerYOffset = 0;

  @override
  void initState() {
    super.initState();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
          if (_keyboardVisibleOnce) {
            _keyboardVisibleTwice = true;
          }
          if (visible) {
            _keyboardVisibleOnce = true;
          }

          // print("Keyboard State Changed : $visible");
        });
      },
    );
  }

  bool isLoading = false;

  Future<void> _signUp() async{
    if(formKeySignUp.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _email = emailTextEditingController.text;
      _password = passwordTextEditingController.text;

      _authService.signUp(_email, _password)
          .catchError((error) {
            return Future.error(error);
          });
    }
  }

  _signIn() {
    if (!_keyboardVisibleTwice) return -1;
    if (formKeySignIn.currentState == null) return -1;
    if(formKeySignIn.currentState.validate()) {
      _email = emailTextEditingController.text;
      _password = passwordTextEditingController.text;

      _authService.signIn(_email, _password).catchError((error){
        // TODO: Handling signin exceptions.
        return -1;
      });
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {

    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    _loginHeight = windowHeight - 270;
    _registerHeight = windowHeight - 270;

    switch(_pageState) {
      case 0:
        _backgroundColor = Colors.white;
        _headingColor = Color(0xFFB40284A);

        _headingTop = 100;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = windowHeight;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _loginXOffset = 0;
        _registerYOffset = windowHeight;
        break;
      case 1:
        _backgroundColor = Color(0xFFBD34C59);
        _headingColor = Colors.white;

        _headingTop = 90;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = _keyboardVisible ? 40 : 270;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _loginXOffset = 0;
        _registerYOffset = windowHeight;
        break;
      case 2:
        _backgroundColor = Color(0xFFBD34C59);
        _headingColor = Colors.white;

        _headingTop = 80;

        _loginWidth = windowWidth - 40;
        _loginOpacity = 0.7;

        _loginYOffset = _keyboardVisible ? 30 : 130;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 130;

        _loginXOffset = 20;
        _registerYOffset = _keyboardVisible ? 55 : 160;
        _registerHeight = _keyboardVisible ? windowHeight : windowHeight - 160;
        break;
    }


    return Stack(
      children: <Widget>[
        AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(
                milliseconds: 1000
            ),
            color: _backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _pageState = 0;
                    });
                  },
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        AnimatedContainer(
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: Duration(
                              milliseconds: 1000
                          ),
                          margin: EdgeInsets.only(
                            top: _headingTop,
                          ),
                          child: Text(
                            "Free Chat",
                            style: TextStyle(
                                color: _headingColor,
                                fontSize: 28
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32
                          ),
                          child: Text(
                            "Chatting and learning online has never been so enjoyable.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: _headingColor,
                                fontSize: 16
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 32
                  ),
                  child: Center(
                    child: Image.asset("assets/images/splash_bg.png"),
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if(_pageState != 0){
                          _pageState = 0;
                        } else {
                          _pageState = 1;
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(32),
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Color(0xFFB40284A),
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Center(
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
        ),
        AnimatedContainer(
          padding: EdgeInsets.all(32),
          width: _loginWidth,
          height: _loginHeight,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(
              milliseconds: 1000
          ),
          transform: Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(_loginOpacity),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25)
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Form(
                key: formKeySignIn,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Login To Continue",
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                    ),
                    InputWithIcon(
                      icon: Icons.email,
                      hint: "Enter Email...",
                      controller: emailTextEditingController,
                      formKey: formKeySignIn,
                    ),
                    SizedBox(height: 20,),
                    HiddenInputWithIconState(
                      icon: Icons.vpn_key,
                      hint: "Enter Password...",
                      controller: passwordTextEditingController,
                      formKey: formKeySignIn,
                      toConfirm: passwordTextEditingController,
                    )
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (_signIn()){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => MainScreen(),
                        ),);
                      }
                    },
                    child: PrimaryButton(
                      btnText: "Login",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _pageState = 2;
                      });
                    },
                    child: OutlineBtn(
                      btnText: "Create New Account",
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        AnimatedContainer(
          height: _registerHeight,
          padding: EdgeInsets.all(32),
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(
              milliseconds: 1000
          ),
          transform: Matrix4.translationValues(0, _registerYOffset, 1),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25)
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Form(
                key: formKeySignUp,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Create a New Account",
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                    ),
                    InputWithIcon(
                      icon: Icons.email,
                      hint: "Enter Email...",
                      controller: emailTextEditingController,
                      formKey: formKeySignUp,
                    ),
                    SizedBox(height: 15,),
                    HiddenInputWithIconState(
                      icon: Icons.vpn_key,
                      hint: "Enter Password...",
                      controller: passwordTextEditingController,
                      formKey: formKeySignUp,
                      toConfirm: passwordTextEditingController,
                    ),
                    SizedBox(height: 15),
                    HiddenInputWithIconState(
                      icon: Icons.vpn_key,
                      hint: "Confirm Password...",
                      controller: confirmPasswordTextEditingController,
                      formKey: formKeySignUp,
                      toConfirm: passwordTextEditingController,
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  GestureDetector(
                    child: PrimaryButton(
                      btnText: "Create Account",
                    ),
                    onTap: (){
                      _signUp();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _pageState = 1;
                      });
                    },
                    child: OutlineBtn(
                      btnText: "Back To Login",
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final btnText;
  PrimaryButton({this.btnText});
  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFB40284A),
          borderRadius: BorderRadius.circular(30)

      ),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
            widget.btnText,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16
            )
        ),

      ),
    );
  }
}

class OutlineBtn extends StatefulWidget {
  final btnText;
  OutlineBtn({this.btnText});
  @override
  _OutlineBtnState createState() => _OutlineBtnState();
}

class _OutlineBtnState extends State<OutlineBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xFFB40284A),
              width: 2
          ),

          borderRadius: BorderRadius.circular(30)

      ),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
            widget.btnText,
            style: TextStyle(
                color: Color(0xFFB40284A),
                fontSize: 16
            )
        ),

      ),
    );
  }
}

class InputWithIcon extends StatefulWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;

  InputWithIcon({this.icon, this.hint, this.controller, this.formKey});

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

// made for emails

class _InputWithIconState extends State<InputWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xFFBC7C7C7),
              width: 2
          ),
          borderRadius: BorderRadius.circular(50)
      ),
      child: Row(
        children: <Widget>[
          Container(
              width: 60,
              child: Icon(
                widget.icon,
                size: 20,
                color: Color(0xFFBB9B9B9),
              )
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  border: InputBorder.none,
                  hintText: widget.hint
              ),
              validator: (val) {
                return emailValidator(val);
              },
              controller: widget.controller,
            ),
          )
        ],
      ),
    );
  }
}


// implemented for password

class HiddenInputWithIconState extends StatefulWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final TextEditingController toConfirm;



  HiddenInputWithIconState({this.icon, this.hint, this.controller, this.formKey, this.toConfirm});

  @override
  _HiddenInputWithIconStateState createState() => _HiddenInputWithIconStateState();
}


class _HiddenInputWithIconStateState extends State<HiddenInputWithIconState> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xFFBC7C7C7),
              width: 2
          ),
          borderRadius: BorderRadius.circular(50)
      ),
      child: Row(
        children: <Widget>[
          Container(
              width: 60,
              child: Icon(
                widget.icon,
                size: 20,
                color: Color(0xFFBB9B9B9),
              )
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  border: InputBorder.none,
                  hintText: widget.hint
              ),
              validator: (val) {
                return passwordValidator(val, widget.toConfirm.text);
              },
              // onSaved: (val) =>  = val,
              obscureText: true,
              controller: widget.controller,
            ),
          )
        ],
      ),
    );
  }
}
