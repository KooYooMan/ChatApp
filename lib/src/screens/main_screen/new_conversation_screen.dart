import 'package:ChatApp/src/models/conversation/conversation.dart';
import 'package:ChatApp/src/models/user/user.dart';
import 'package:ChatApp/src/screens/conversation_screens/conversation_screen.dart';
import 'package:ChatApp/src/screens/fake_data/fake_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ChatApp/src/services/auth_service.dart';
import 'package:ChatApp/src/services/message_service.dart';

class NewConversationScreen extends StatefulWidget {
  NewConversationScreen({Key key}) : super(key: key);

  @override
  _NewConversationScreenState createState() => new _NewConversationScreenState();
}

class _NewConversationScreenState extends State<NewConversationScreen> {
  AuthService _authService = GetIt.I.get<AuthService>();
  MessageService _messageService = GetIt.I.get<MessageService>();
  User currentUser = null;
  bool _loading = true;
  List<User> favorites = null;
  List<User> userList = List<User>();
  TextEditingController _controller;
  List<User> renderList = List<User>();
  List<User> curList = List<User>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _authService.getAllUsers().then((result) {
      favorites = result;
      userList.clear();
      userList.addAll(favorites);

      _authService.getCurrentDartUser().then((user) {
        currentUser = user;
        setState(() {
          _loading = false;
        });
      });
    });
  }

  // void dispose() {
    // _controller.dispose();
    // super.dispose();
  // }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<User> allCopy = List<User>();
      allCopy.addAll(userList);
      List<User> filterList = List<User>();
      allCopy.forEach((element) {
        if (element.displayName.contains(query) && element.uid != _authService.getCurrentUID()) {
          bool appearInCurList = false;
          for (int i = 0; i < curList.length; i++) {
            if (element.uid == curList[i].uid) {
              appearInCurList = true;
            }
          }
          if (!appearInCurList) filterList.add(element);
        }
      });
      setState(() {
        renderList.clear();
        renderList.addAll(filterList);
      });
    } else {
      setState(() {
        renderList.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: TextField(
            onChanged: (value) {
              filterSearchResults(value);
            },
            style: TextStyle(color: Colors.black, fontSize: 17.0),
            controller: _controller,
            decoration: InputDecoration.collapsed(
              hintText: "Search for participants",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 17.0),
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () async {
                  if (curList.isNotEmpty) {
                    List <User> members = [];
                    members.addAll(curList);
                    members.add(currentUser);
                    Conversation newConversation = await _messageService.addGroupConversation(members);
                    print(newConversation.users);
                    print(newConversation.displayName);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => Material(
                        child: Scaffold(
                            resizeToAvoidBottomInset: false,
                            body: Container(
                              child: ConversationScreen(newConversation),
                            )
                        ),
                      ),
                    ));
                    print("OK");
                  }
                },

                child: Center(
                  child: Text(
                    "Create",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: curList.isEmpty ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: _loading? Center(child: CircularProgressIndicator()) : Column( // TODO: align CPI to center
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (curList.isNotEmpty) ? Container(
                height: 95.0,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 10.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: curList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 25.0,
                                    backgroundImage: curList[index].avatarProvider,
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        curList.removeAt(index);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.cancel, color: Colors.white, size: 15.0,)
                                      ),
                                    ),

                                  )
                                ],

                              ),
                            ],
                          ),
                          SizedBox(height: 6.0),
                          Text(
                            curList[index].displayName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ) : Container(),
              SizedBox(
                height: 10.0,
              ),
              (curList.isNotEmpty) ? Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Text(
                  "Suggested",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                ),
              ) : Container(),
              (curList.isNotEmpty) ? SizedBox(
                height: 6.0,
              ) : Container(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: renderList.length,
                  itemBuilder: (context, index) {
                    return FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      onPressed: () {
                        setState(() {
                          curList.add(renderList[index]);
                          userList.remove(renderList[index]);
                          renderList = List<User>();
                          _controller = new TextEditingController(text: '');
                        });
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 10.0,),
                          CircleAvatar(
                            backgroundImage: renderList[index].avatarProvider,
                            radius: 25.0,
                          ),
                          SizedBox(width: 10.0,),
                          Text('${renderList[index].displayName}'),
                        ]
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
