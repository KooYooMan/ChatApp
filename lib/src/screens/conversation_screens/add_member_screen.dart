import 'package:ChatApp/src/models/user/user.dart';
import 'package:ChatApp/src/screens/conversation_screens/conversation_screen.dart';
import 'package:ChatApp/src/screens/conversation_screens/widgets/circular_image.dart';
import 'package:ChatApp/src/screens/fake_data/fake_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddMemberScreen extends StatefulWidget {
  @override
  _AddMemberScreenState createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  TextEditingController _findMemberController = TextEditingController();
  List<User> users = fakeDatabase.getUsers("");
  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: Colors.black,),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: TextField(
        onChanged: (text) {
          if (text.length == 0) {
            print("Show recently contact");
            setState(() {
              users = fakeDatabase.getUsers(text);
            });
          } else {
            print("Show people name contain $text");
            setState(() {
              users = fakeDatabase.getUsers(text);
            });
          }
        },
        controller: _findMemberController,
        decoration: InputDecoration(
          hintText: "Find person",
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            String userName = users[index].displayName;
            return FlatButton(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              onPressed: () {
                showDialog(context: context, builder: (_) {
                  return AlertDialog(
                    title: const Text("Add member"),
                    content: Text("Confirm add $userName"),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          //TODO: add this person
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Text("Yes"),
                      ),
                      FlatButton(
                        onPressed: () {
                          //TODO: do nothing
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Text("No"),
                      )
                    ],
                  );
                });
              },
              child: Row(
                children: [
                  SizedBox(width: 20.0),
                  CircleAvatar(
                    backgroundImage: users[index].avatarProvider,
                    radius: 17.0,
                  ),
                  SizedBox(width: 20.0,),
                  Text(users[index].displayName, style: TextStyle(fontSize: 15.0),),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

