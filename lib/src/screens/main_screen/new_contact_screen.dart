import 'package:ChatApp/src/models/conversation/conversation.dart';
import 'package:ChatApp/src/models/user/user.dart';
import 'package:ChatApp/src/screens/conversation_screens/conversation_screen.dart';
import 'package:ChatApp/src/screens/fake_data/fake_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ChatApp/src/services/auth_service.dart';
import 'package:ChatApp/src/services/message_service.dart';

class NewContactScreen extends StatefulWidget {
  NewContactScreen({Key key}) : super(key: key);

  @override
  _NewContactScreenState createState() => new _NewContactScreenState();
}

class _NewContactScreenState extends State<NewContactScreen> {
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
  }

  // void dispose() {
  // _controller.dispose();
  // super.dispose();
  // }

  void filterSearchResults(String query) {
    print("query = $query");
    if (query.isNotEmpty) {
      List<User> allCopy = List<User>();
      allCopy.addAll(userList);
      List<User> filterList = List<User>();
      allCopy.forEach((element) {
        if (element.displayName.contains(query) && element.uid != _authService.getCurrentUID()) {
          filterList.add(element);
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
    _authService.getAllUsers().then((result) {
      favorites = result;
      userList.clear();
      userList.addAll(favorites);

      _authService.getCurrentDartUser().then((user) {
        currentUser = user;
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      });
    });

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
                hintText: "Search for contact",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 17.0),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: _loading? Center(child: CircularProgressIndicator()) : Column( // TODO: align CPI to center
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: renderList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          curList.add(renderList[index]);
                          userList.remove(renderList[index]);
                          renderList = List<User>();
                          _controller = new TextEditingController(text: '');
                        });
                      },
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        onPressed: () async {
                          Conversation newConversation = await _messageService.addConversation(currentUser, renderList[index]);
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
