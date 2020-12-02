import 'dart:io';

import 'package:ChatApp/src/models/message/document_message.dart';
import 'package:ChatApp/src/models/message/image_message.dart';
import 'package:ChatApp/src/screens/conversation_screens/image_view_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/src/models/message/message.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageWidget extends StatefulWidget {
  MessageWidget(this.message, this.isSentByMe);
  final Message message;
  final bool isSentByMe;
  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  Future<String> _findLocalPath() async {
    final platform = Theme.of(context).platform;

    final directory = platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Widget _buildDocumentMessage() {
    Color decorationColor = (widget.isSentByMe) ? Colors.cyan : Colors.grey[300];
    Color textColor = (widget.isSentByMe) ? Colors.white : Colors.black;
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        child: Row(
          children: [
            Center(
              child: Icon(
                Icons.file_download,
                size: 16,
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 3 * 2,
              ),
              child: RichText(
                text: TextSpan(
                  text: (widget.message as DocumentMessage).documentName,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: textColor
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Download " + (widget.message as DocumentMessage).documentName),
                        content: Text("Do you accept?"),
                        actions: [
                          FlatButton(
                            onPressed: () async {
                              var _localPath = (await _findLocalPath()) + '/Downloads';

                              final savedDir = Directory(_localPath);
                              bool hasExisted = await savedDir.exists();
                              if (!hasExisted) {
                                savedDir.create();
                              }

                              final taskId = await FlutterDownloader.enqueue(
                                url: (widget.message as DocumentMessage).content,
                                savedDir: _localPath,
                                showNotification: true, // show download progress in status bar (for Android)
                                openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                              );
                              Navigator.of(context, rootNavigator: true).pop();
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
                  }
                ),
              ),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: decorationColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
  Widget _buildImageMessage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image(
        image: (widget.message as ImageMessage).imageProvider,
        fit: BoxFit.fill,
        width: (MediaQuery.of(context).size.width - 30) / 2,
      ),
    );
  }
  Widget _buildTextMessage() {
    Color decorationColor = (widget.isSentByMe) ? Colors.cyan : Colors.grey[300];
    Color textColor = (widget.isSentByMe) ? Colors.white : Colors.black;
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 3 * 2,
      ),
      child: Text(
        widget.message.toString(),
        style: TextStyle(color: textColor),
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      decoration: BoxDecoration(
        color: decorationColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
  Widget _buildMessage() {
    if (widget.message.type == MessageType.image) {
      return _buildImageMessage();
    }
    if (widget.message.type == MessageType.document) {
      return _buildDocumentMessage();
    }
    return _buildTextMessage();
  }
  @override
  Widget build(BuildContext context) {
    if (widget.isSentByMe) {
      return Container(
        child: Row(
          children: [
            _buildMessage(),
            SizedBox(width: 5.0),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
        padding: EdgeInsets.only(bottom: 2.0, right: 10.0),
      );
    } else {
      return Container(
        child: Row(
          children: [
            SizedBox(width: 5.0),
            _buildMessage(),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        padding: EdgeInsets.only(bottom: 2.0),
      );
    }
  }
}

