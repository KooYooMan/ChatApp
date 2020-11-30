import 'dart:io';

import 'package:ChatApp/src/models/conversation/conversation.dart';
import 'package:ChatApp/src/screens/conversation_screens/add_member_screen.dart';
import 'package:ChatApp/src/screens/conversation_screens/decorations/decorations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ConversationInfoScreen extends StatefulWidget {
  ConversationInfoScreen(this.uid, this.conversation);
  final String uid;
  final Conversation conversation;

  @override
  _ConversationInfoScreenState createState() => _ConversationInfoScreenState();
}

class _ConversationInfoScreenState extends State<ConversationInfoScreen> {
  File _image;
  ImagePicker _imagePicker = ImagePicker();

  _imageFromGallery() async {
    File file = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);

    setState(() {
      _image = File(file.path);
    });
  }
  _imageFromCamera() async {
    var image = await _imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(image.path);
    });
  }
  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded),
        iconSize: 25.0,
        color: Colors.black,
        onPressed: () {
          Navigator.pop(context);
        },

      ),
      actions: [
        PopupMenuButton(
          onSelected: (result) {
            if (result == 1) {
              print("delete");
            } else if (result == 2) {
              print("report");
            } else {
              print("other");
            }
          },
          icon: Icon(
              Icons.more_vert,
              color: Colors.black
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text("Delete conversation"),
            ),
            PopupMenuItem(
              value: 2,
              child: Text('Report issues'),
            )
          ]
        )
      ],
    );
  }

  Future<void> _askToChooseImageSource() async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Change conversation avatar"),
          children: [
            SimpleDialogOption(
              onPressed: () {
                _imageFromCamera();
              },
              child: Container(
                padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                child: const Text("Image from camera")
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                _imageFromGallery();
              },
              child: Container(
                padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                child: const Text("Image from gallery")
              ),
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    bool test = true;
    // return Container();
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Scaffold(
          body: Column(
            children: [
              SizedBox(height: 20.0,),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _askToChooseImageSource();
                  },
                  child: CircleAvatar(
                    backgroundImage: widget.conversation.avatarProvider,
                    radius: 50.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: Text(
                  widget.conversation.displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: greyCircleDecoration(),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.call,
                            color: Colors.black,
                            size: 20.0,
                          ),
                        ),
                      ),
                      Text("Call"),
                    ],
                  ),
                  SizedBox(width: 30.0,),
                  Column(
                    children: [
                      Container(
                        decoration: greyCircleDecoration(),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.video_call,
                            color: Colors.black,
                            size: 20.0,
                          ),
                        ),
                      ),
                      Text("Video"),
                    ],
                  ),
                  SizedBox(width: 30.0,),
                  Column(
                    children: [
                      Container(
                        decoration: greyCircleDecoration(),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.notifications,
                            color: Colors.black,
                            size: 20.0,
                          ),
                        ),
                      ),
                      Text("On"),
                    ],
                  ),
                  (widget.conversation.isPrivate) ? SizedBox(width: 30.0,) : Container(),
                  (widget.conversation.isPrivate) ? Column(
                    children: [
                      Container(
                        decoration: greyCircleDecoration(),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => AddMemberScreen()),
                            );
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 20.0,
                          ),
                        ),
                      ),
                      Text("Add"),
                    ],
                  ) : Container(),
                ],
              ),
              SizedBox(height: 20.0,),
              FlatButton(
                onPressed: () {

                },
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                child: Row(
                  children: [
                    Text(
                      "View videos and images",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Spacer(),
                    Container(
                      decoration: greyCircleDecoration(),
                      padding: EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.image,
                        size: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {

                },
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                child: Row(
                  children: [
                    Text(
                      "Search in conversation",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Spacer(),
                    Container(
                      decoration: greyCircleDecoration(),
                      padding: EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.search,
                        size: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {},
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                child: Row(
                  children: [
                    Text(
                      "Leave conversation",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Spacer(),
                    Container(
                      decoration: greyCircleDecoration(),
                      padding: EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.exit_to_app,
                        size: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
