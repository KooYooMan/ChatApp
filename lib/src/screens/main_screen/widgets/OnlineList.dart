import 'package:ChatApp/src/models/user/user.dart';
import 'package:ChatApp/src/screens/fake_data/fake_users.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

class OnlineList extends StatefulWidget {
  @override
  _OnlineListState createState() => _OnlineListState();
}

class _OnlineListState extends State<OnlineList> {
  List<User> onlineList = favorites;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: ListView.builder(
          itemCount: onlineList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Text("Hello World!"),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Color(0xFFFFEFEE),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 35.0,
                          backgroundImage: AssetImage(onlineList[index].avatar),
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                onlineList[index].displayName,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        new DotsIndicator(
                          dotsCount: 1,
                          position: 0,
                          decorator: DotsDecorator(
                            activeColor: Colors.green,
                            shape: const Border(),
                            activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
