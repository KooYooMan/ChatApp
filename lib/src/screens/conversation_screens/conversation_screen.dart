import 'dart:async';
import 'dart:io';

import 'package:ChatApp/src/models/message/message.dart';
import 'package:ChatApp/src/models/conversation/conversation.dart';
import 'package:ChatApp/src/screens/conversation_screens/widgets/circular_image.dart';
import 'package:ChatApp/src/screens/conversation_screens/widgets/message_widget.dart';
import 'package:ChatApp/src/screens/conversation_screens/widgets/name_widget.dart';
import 'package:ChatApp/src/screens/conversation_screens/widgets/time_stamp_widget.dart';
import 'package:ChatApp/src/screens/fake_data/fake_database.dart';
import 'package:ChatApp/src/utils/emoji_converter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';



class ConversationScreen extends StatefulWidget {
  final String uid;
  final Conversation conversation;
  final Stream<Message> messageStream;
  ConversationScreen(this.uid, this.conversation, this.messageStream);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}


class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _textEditingController = new TextEditingController();
  // ignore: close_sinks
  final StreamController<Message> messageStreamController = new StreamController();

  ScrollController _messageListScrollController = ScrollController();
  File _image;
  File _file;
  String _filePath;
  List<File> _files;
  ImagePicker _imagePicker = ImagePicker();

  //event function
  _imageFromGallery() async {
    var image = await _imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
  }
  _imageFromCamera() async {
    var image = await _imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(image.path);
    });
  }
  void _showImagePicker(context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (context) {
        return new Container(
          height: 200.0,
          child: Column(
            children: [
              Container(
                child: Text(
                  "Choose your source",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 5.0,),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 100.0,
                    ),
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Icon(Icons.photo_library),
                          SizedBox(height: 10.0,),
                          Text(
                            'Photo Library',
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        print("Image from gallery");
                        _imageFromGallery();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 50.0,
                          ),
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(Icons.photo_camera),
                            onPressed: () {
                              print("image from camera");
                              _imageFromCamera();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Text('Photo Camera'),
                      ]
                  )
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  ///File function
  _filePathFromDevice() async {
    String path = await FilePicker.getFilePath();
    setState(() {
      _filePath = path;
    });
  }

  _filesFromDevice() async {
    List<File> files = await FilePicker.getMultiFile();
    setState(() {
      _files = files;
    });
  }
  _fileFromDevice() async {
    File file = await FilePicker.getFile();
    setState(() {
      _file = file;
    });
  }
  Widget _buildAppBar() {
    return AppBar(
      leading: FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Icon(
            Icons.arrow_back_rounded,
            size: 30.0,
            color: Colors.white,
          ),
        ),
      ),
      title: Row(
        children: [
          CircularImage(widget.conversation.avatarProvider),
          SizedBox(width: 8.0),
          Container(
            child: Text(
              widget.conversation.displayName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]
      ),
      elevation: 0.0,
      actions: [
        Container(
          constraints: BoxConstraints(
              maxWidth: 50.0
          ),
          child: FlatButton(
              onPressed: (){},
              child: Icon(
                Icons.call,
                color: Colors.white,
              )
          ),
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: 50.0
          ),
          child: FlatButton(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            onPressed: (){},
            child: Center(
              child: Icon(
                Icons.info,
                color: Colors.white,
              ),
            )
          ),
        ),
        SizedBox(width: 5.0)
      ],
      backgroundColor: Colors.red,
    );
  }

  Widget _buildInputWidget() {
    return Container(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: [
            SizedBox(height: 5.0,),
            Row(
              children: [
                SizedBox(width: 8,),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(13.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                      controller: _textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: "Viết tin nhắn",
                        fillColor: Colors.grey
                      ),
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 50.0,
                  ),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    onPressed: () {
                      //TODO: send message to
                      _textEditingController.clear();
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.redAccent,
                      //TODO: do actually onPressed function
                    ),
                  ),
                )
              ],
            ),
            Row(
              //TODO: do option for gif, icon, ...
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 50.0
                  ),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 1.0),
                    onPressed: () {},
                    child: Icon(
                      Icons.face,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: 50.0
                  ),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 1.0),
                    onPressed: () {
                      _imageFromCamera();
                    },
                    child: Icon(
                      Icons.image,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: 50.0
                  ),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 1.0),
                    onPressed: () {
                      _filesFromDevice();
                    },
                    child: Icon(
                      Icons.attach_file,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  Widget _buildMessageListWidget() {
    return StreamBuilder(
      stream: widget.messageStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          widget.conversation.addMessage(snapshot.data);
        }
        return Expanded(
          child: ListView.builder(
            controller: _messageListScrollController,
            itemCount: widget.conversation.messageList.length,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (context, index) {
              int length = widget.conversation.messageList.length;
              int currIdx = length - index - 1;
              bool isSentByMe = widget.uid == widget.conversation.messageList[currIdx].uid;
              Message currMess = widget.conversation.messageList[currIdx];
              int nextIdx = currIdx + 1;
              Widget w;
              bool showName = false;
              bool showTime = false;

              if (((nextIdx < length && widget.conversation.messageList[nextIdx].uid != currMess.uid) || nextIdx >= length)) {
                if (isSentByMe) {
                  w = Column(
                    children: [
                      MessageWidget(widget.conversation.messageList[currIdx], isSentByMe),
                      SizedBox(height: 5.0,),
                    ],
                  );
                } else {
                  w = Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10.0,),
                          CircularImage(currMess.avatarProvider),
                          MessageWidget(currMess, isSentByMe),
                        ],
                      ),
                      SizedBox(height: 5.0,)
                    ]
                  );
                }
              } else {
                if (isSentByMe) {
                  w = MessageWidget(widget.conversation.messageList[currIdx], isSentByMe);
                } else {
                  w = Row(
                    children: [
                      SizedBox(width: 40.0),
                      MessageWidget(currMess, isSentByMe)
                    ],
                  );
                }
              }
              w = GestureDetector(
                onLongPress: () {
                  showMenu(
                    position: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    context: context,
                    items: <PopupMenuEntry>[
                      
                    ],
                  );
                },
                child: w,
              );
              int prevIdx = currIdx - 1;
              if ((prevIdx >= 0 && currMess.sentTime.difference(widget.conversation.messageList[prevIdx].sentTime).inMinutes >= 15) || prevIdx < 0) {
                showTime = true;
              }
              if ((prevIdx >= 0 && widget.conversation.messageList[prevIdx].uid != currMess.uid) || prevIdx < 0) {
                showName = true;
              } else {
                showName = showTime;
              }
              if (showName && !isSentByMe) {
                w = Column(
                  children: [
                    NameWidget(currMess.userDisplayName),
                    w
                  ],
                );
              }
              if (showTime) {
                w = Column(
                  children: [
                    TimeStampWidget(currMess.sentTime),
                    SizedBox(height: 10.0),
                    w
                  ],
                );
              }
              return w;
            }
          ),
        );
      }
    );

  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildMessageListWidget(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: _buildInputWidget(),
            )
          ],
        )
      )
    );
  }
}

ConversationScreen fakeConversationScreen(String cid) {
  Conversation fakeConversation = fakeDatabase.getConversationByCid(cid);
  ConversationScreen conversationScreen = ConversationScreen("uid0", fakeConversation, fakeDatabase.getMessageStreamByCid(fakeConversation.cid));
  return conversationScreen;
}

