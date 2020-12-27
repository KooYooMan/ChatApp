import 'package:ChatApp/src/screens/auth_screens/main.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ChatApp/src/services/auth_service.dart';

class Info extends StatelessWidget {
  AuthService _authService = GetIt.I.get<AuthService>();

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.

    final features = ["Email:", "Password: "];
    final contents = [_authService.getCurrentUser().email, "************"];

    final icons = ['email.png', 'password.png'];

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Profile'),
          actions: <Widget>[
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  iconSize: 30.0,
                  color: Colors.black,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Log Out"),
                        content: Text("Do you want to log out?"),
                        actions: [
                          FlatButton(
                            onPressed: () async {
                              _authService.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Material(
                                    child: Scaffold(
                                        resizeToAvoidBottomInset: false,
                                        body: Container(child: AuthScreen())),
                                  ),
                                ),
                              );
                            },
                            child: Text("Yes"),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text("No"),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        // body is the majority of the screen.
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.white),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(
                            _authService.getCurrentUser().photoURL),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        _authService.getCurrentUser().displayName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                      child: ListView.separated(
                          itemCount: 2,
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(height: 0.25),
                          itemBuilder: (BuildContext context, int index) {
                            final property = features[index];
                            final content = contents[index];
                            final icon = icons[index];
                            return Container(
                              height: 80.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        new Container(
                                            width: 40.0,
                                            height: 40.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: new AssetImage(
                                                        './assets/images/$icon')))),
                                        SizedBox(width: 10.0),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              property,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(content)
                                  ],
                                ),
                              ),
                            );
                          })))
            ],
          ),
        ));
  }
}
