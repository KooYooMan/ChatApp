import 'package:ChatApp/src/models/user/user.dart';
import 'package:ChatApp/src/screens/fake_data/fake_database.dart';
import 'package:flutter/material.dart';

class NewConversation extends StatefulWidget {
  NewConversation({Key key}) : super(key: key);

  @override
  _NewConversation createState() => new _NewConversation();
}

class _NewConversation extends State<NewConversation> {
  List<User> favorites = fakeDatabase.getFavorites();
  List<User> userList = List<User>();
  TextEditingController _controller;
  List<User> renderList = List<User>();
  List<User> curList = List<User>();

  void initState() {
    super.initState();
    _controller = TextEditingController();
    userList.addAll(favorites);
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<User> allCopy = List<User>();
      allCopy.addAll(userList);
      List<User> filterList = List<User>();
      allCopy.forEach((element) {
        if (element.displayName.contains(query)) {
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
        renderList.addAll(userList);
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
          title: Text('New conversation'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'To',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 95.0,
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 10.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: curList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Text("Hello World!"),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 25.0,
                                    backgroundImage: curList[index].avatarProvider,
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.0),
                              Text(
                                curList[index].displayName,
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 6.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      filterSearchResults(value);
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
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
                        child: ListTile(
                          title: Text('${renderList[index].displayName}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}