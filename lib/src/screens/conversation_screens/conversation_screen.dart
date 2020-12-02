import 'dart:async';
import 'dart:io';
import 'package:ChatApp/src/models/message/document_message.dart';
import 'package:ChatApp/src/models/message/text_message.dart';
import 'package:ChatApp/src/screens/conversation_screens/call_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:ChatApp/src/models/message/image_message.dart';
import 'package:ChatApp/src/models/message/message.dart';
import 'package:ChatApp/src/models/conversation/conversation.dart';
import 'package:ChatApp/src/screens/conversation_screens/conversation_info_screen.dart';
import 'package:ChatApp/src/screens/conversation_screens/widgets/circular_image.dart';
import 'package:ChatApp/src/screens/conversation_screens/widgets/message_widget.dart';
import 'package:ChatApp/src/screens/conversation_screens/widgets/name_widget.dart';
import 'package:ChatApp/src/screens/conversation_screens/widgets/time_stamp_widget.dart';
import 'package:ChatApp/src/screens/fake_data/fake_database.dart';
import 'package:ChatApp/src/utils/emoji_converter.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'image_view_screen.dart';

import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ChatApp/src/services/auth_service.dart';
import 'package:ChatApp/src/services/message_service.dart';
import 'package:ChatApp/src/services/storage_service.dart';

import 'package:path/path.dart' as pathlib;



class ConversationScreen extends StatefulWidget {
  Conversation conversation;
  ConversationScreen(this.conversation);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}


class _ConversationScreenState extends State<ConversationScreen> {
  AuthService _authService = GetIt.I.get<AuthService>();
  MessageService _messageService = GetIt.I.get<MessageService>();
  StorageService _storageService = GetIt.I.get<StorageService>();

  final TextEditingController _textEditingController = new TextEditingController();
  // ignore: close_sinks
  final StreamController<Message> messageStreamController = new StreamController();
  final String gifAPIKey = 'jmLMn13KlLFxRWv8izG4euJY4xsICx0d';
  ScrollController _messageListScrollController = ScrollController();
  File _image;
  File _file;
  String _filePath;
  List<File> _files;
  ImagePicker _imagePicker = ImagePicker();
  bool _keyboardVisible = false;
  bool _showEmojiPicker = false;

  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool isVisible) {
        setState(() {
          _keyboardVisible = isVisible;
          if (_keyboardVisible == true && _showEmojiPicker == true) {
            _showEmojiPicker = false;
          }
        });
      }
    );
  }
  //event function
  _imageFromGallery() async {
    File file = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);
    setState(() {
      if (file != null) {
        print(file.path);
        _image = file;
      } else {
        print("NULL");
      }
    });

    String fileName = "${DateTime.now().millisecondsSinceEpoch}.png";

    await _storageService.uploadFile(_image, "${widget.conversation.cid}/${fileName}");

    _storageService.getDownloadURL("${widget.conversation.cid}/${fileName}").then((url){
      _messageService.addImageMessage(widget.conversation, _authService.getCurrentUID(), url);
    });
  }


  _imageFromCamera() async {
    var image = await _imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      print(image.path);
      _image = File(image.path);
    });

    String fileName = "${DateTime.now().millisecondsSinceEpoch}.png";

    await _storageService.uploadFile(_image, "${widget.conversation.cid}/${fileName}");

    _storageService.getDownloadURL("${widget.conversation.cid}/${fileName}").then((url){
      _messageService.addImageMessage(widget.conversation, _authService.getCurrentUID(), url);
    });
  }

  _filesFromDevice() async {
    List<File> files = await FilePicker.getMultiFile();
    setState(() {
      _files = files;
    });
    _files.forEach((file) async {
      String fileName = pathlib.basename(file.path);
      await _storageService.uploadFile(file, "${widget.conversation.cid}/${fileName}");

      _storageService.getDownloadURL("${widget.conversation.cid}/${fileName}").then((url){
        _messageService.addDocumentMessage(widget.conversation, _authService.getCurrentUID(), url, fileName);
      });
    });
  }

  _giphyPicker() async {
    final gif = await GiphyPicker.pickGif(context: context, apiKey: gifAPIKey);
    print(gif.images.original.url);
    _messageService.addImageMessage(widget.conversation, _authService.getCurrentUID(), gif.images.original.url);
  }

  Future<void> _handleCameraAndMic() async {
    await [Permission.camera, Permission.microphone].request();
  }
  Future<void> _onJoin() async {
    await _handleCameraAndMic();
    //TODO: add an entry agoraID, avatar. => get user avatar when disable video.
    //TODO: maintain map<agoraID, bool> camera, => camera status of agoraID.

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CallScreen(channelName: widget.conversation.cid,))
    );
  }
  Widget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        iconSize: 25.0,
        color: Colors.cyan[800],
        icon: Icon(Icons.arrow_back_rounded),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Row(
        children: [
          CircularImage(NetworkImage(_authService.getCurrentUser().photoURL)), //TODO: change avatar
          SizedBox(width: 8.0),
          Container(
            child: Text(
              widget.conversation.displayName,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        ]
      ),
      elevation: 0.0,
      actions: [
        IconButton(
          iconSize: 25.0,
          icon: Icon(Icons.call, color: Colors.cyan[800],),
          onPressed: () => _onJoin(),
        ),
        IconButton(
          iconSize: 25.0,
          icon: Icon(Icons.info, color: Colors.cyan[800],),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ConversationInfoScreen(_authService.getCurrentUID(), widget.conversation) // TODO: Check if right person
              )
            );
          }
        ),
        SizedBox(width: 5.0)
      ],
      backgroundColor: Colors.white,
    );
  }
  Widget _buildEmojiPicker() {
    return EmojiPicker(
      rows: 2,
      columns: 7,
      buttonMode: ButtonMode.MATERIAL,
      onEmojiSelected: (emoji, category) {
        print(emoji);
        _textEditingController.text += emoji.emoji;
      },
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
                IconButton(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  onPressed: () {
                    setState(() {
                      _showEmojiPicker = !_showEmojiPicker;
                      if (_showEmojiPicker == true && _keyboardVisible == true) {
                        FocusScope.of(context).unfocus();
                      }
                    });
                  },
                  icon: Icon(Icons.face),
                  color: Colors.cyan[800],
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 12.0, right: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height / 6,
                    ),
                    child: TextFormField(
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: "Aa",
                        fillColor: Colors.grey
                      ),
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  onPressed: () {
                    if (_textEditingController.text.length == 0) {
                      return;
                    }
                    print(_textEditingController.text);
                    String content = _textEditingController.text;
                    _messageService.addTextMessage(widget.conversation, _authService.getCurrentUID(), content);
                    _textEditingController.clear();
                  },
                  icon: Icon(Icons.send, color: Colors.cyan[800],),
                )
              ],
            ),
            (_keyboardVisible == false) ? Row(
              //TODO: do option for gif, icon, ...
              children: [
                IconButton(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  onPressed: () {
                    _imageFromCamera();
                  },
                  icon: Icon(Icons.camera_alt),
                  color: Colors.cyan[800],
                ),
                IconButton(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  onPressed: () {
                    _imageFromGallery();
                  },
                  icon: Icon(Icons.image_outlined),
                  color: Colors.cyan[800],
                ),
                IconButton(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  onPressed: () {
                    _filesFromDevice();
                  },
                  icon: Icon(Icons.attach_file),
                  color: Colors.cyan[800],
                ),
                IconButton(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  onPressed: () {
                    _giphyPicker();
                  },
                  icon: Icon(Icons.gif),
                  color: Colors.cyan[800],
                )
              ],
            ) : Container(),
          ],
        ),
      ),
    );
  }
  Widget _buildMessageListWidget() {
    return StreamBuilder(
      stream: _messageService.getMessages(widget.conversation.cid),
      builder: (context, snapshot) {
        List<Message> list = [];
        if (snapshot.hasData) {
          Map data = snapshot.data.snapshot.value;
          if (data != null)
            data.forEach((key, value) {
              if (value['type'] == MessageType.text.index)
                list.add(TextMessage.fromSnapshot(key, value));
              if (value['type'] == MessageType.image.index)
                list.add(ImageMessage.fromSnapshot(key, value));
              if (value['type'] == MessageType.document.index)
                list.add(DocumentMessage.fromSnapshot(key, value));
            });
          list.sort((Message a, Message b) => (a.sentTime.millisecondsSinceEpoch - b.sentTime.millisecondsSinceEpoch));
        }
        return Flexible(
          fit: FlexFit.tight,
          child: ListView.builder(
            controller: _messageListScrollController,
            itemCount: list.length,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (context, index) {
              int length = list.length;
              int currIdx = length - index - 1;
              bool isSentByMe = _authService.getCurrentUID() == list[currIdx].sender;
              Message currMess = list[currIdx];
              int nextIdx = currIdx + 1;
              Widget w;
              bool showName = false;
              bool showTime = false;
              w = MessageWidget(list[currIdx], isSentByMe);
              if (currMess.type == MessageType.image) {
                w = GestureDetector(
                  onTap: () {
                    print("Tap tap");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ImageScreen(widget.conversation.displayName, (currMess as ImageMessage).imageProvider))
                    );
                  },
                  child: w,
                );
              }
              var popupAvatar = PopupMenuButton(
                onSelected: (result) {
                  if (result == 1) {
                    print("delete");
                  } else if (result == 2) {
                    print("report");
                  } else {
                    print("other");
                  }
                },
                itemBuilder: (context) => [
                  (widget.conversation.isPrivate) ? PopupMenuItem(
                    value: 3,
                    child: Text('Send private message'),
                  ) : null,
                  PopupMenuItem(
                    value: 1,
                    child: Text("Voice call"),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text('Video call'),
                  ),
                ],
                child: CircularImage(NetworkImage(_authService.getCurrentUser().photoURL)),  // TODO : get exact image
              );
              if (((nextIdx < length && list[nextIdx].sender != currMess.sender) || nextIdx >= length)) {
                if (isSentByMe) {
                  w = Column(
                    children: [
                      w,
                      SizedBox(height: 5.0,),
                    ],
                  );
                } else {
                  w = Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10.0,),
                          popupAvatar,
                          w,
                        ],
                      ),
                      SizedBox(height: 5.0,)
                    ]
                  );
                }
              } else {
                if (!isSentByMe) {
                  w = Row(
                    children: [
                      SizedBox(width: 40.0),
                      w
                    ],
                  );
                }
              }

              int prevIdx = currIdx - 1;
              if ((prevIdx >= 0 && currMess.sentTime.difference(list[prevIdx].sentTime).inMinutes >= 15) || prevIdx < 0) {
                showTime = true;
              }
              if ((prevIdx >= 0 && list[prevIdx].sender != currMess.sender) || prevIdx < 0) {
                showName = true;
              } else {
                showName = showTime;
              }
              if (showName && !isSentByMe) {
                w = Column(
                  children: [
                    NameWidget(widget.conversation.displayName),
                    w
                  ],
                );
              }
              //print("text = " + currMess.content.text + " showtime = " + (showTime ? "true" : "false") + " uid = " + currMess.sender + " name = " + "TODO");
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
            ),
            (_showEmojiPicker) ? _buildEmojiPicker() : Container(),
          ],
        )
      )
    );
  }
}

ConversationScreen fakeConversationScreen(String cid) {
  Conversation fakeConversation = fakeDatabase.getConversationByCid(cid);
  ConversationScreen conversationScreen = ConversationScreen(fakeConversation);
  return conversationScreen;
}

