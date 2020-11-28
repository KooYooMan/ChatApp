import 'package:flutter/material.dart';

class GetStartedScreen extends StatefulWidget {
  final Function() switchPage;
  GetStartedScreen({this.switchPage});
  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final formKeySignIn = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(height: 5.0,),
            Column(
              children: <Widget>[
                Container(
                  child: Text(
                    "Free Chat",
                    style: TextStyle(
                        fontSize: 28
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.symmetric(
                    horizontal: 32
                  ),
                  child: Text(
                    "Chatting and learning online has never been so enjoyable.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                )
              ],
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
                onTap: widget.switchPage,
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
        ),
      ),
    );
  }
}
