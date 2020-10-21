import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final features = [
    "Email:",
    "Password: ",
    "Phone number: ",
    "Phone number: ",
    "Phone number: ",
    "Phone number: ",
    "Phone number: ",
    "Phone number: ",
    "Phone number: "
  ];
  final contents = [
    "manhcaoduy1912@gmail.com",
    "************",
    "0941525452",
    "0941525452",
    "0941525452",
    "0941525452",
    "0941525452",
    "0941525452",
    "0941525452"
  ];

  final icons = [
    'email.png',
    'password.png',
    'phone.png',
    'phone.png',
    'phone.png',
    'phone.png',
    'phone.png',
    'phone.png',
    'phone.png'
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Profile'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () {},
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
                        backgroundImage: AssetImage("assets/images/avatar.jpg"),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Manh Cao Duy",
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
                          itemCount: 9,
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
