import 'package:ChatApp/src/models/message/document_message.dart';
import 'package:ChatApp/src/models/message/image_message.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/src/models/message/message.dart';

class MessageWidget extends StatefulWidget {
  MessageWidget(this.message, this.isSentByMe);
  final Message message;
  final bool isSentByMe;
  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {

  Widget _buildDocumentMessage() {
    Color decorationColor = (widget.isSentByMe) ? Colors.red : Colors.grey[300];
    Color textColor = (widget.isSentByMe) ? Colors.white : Colors.black;
    print((widget.message as DocumentMessage).documentName);
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
    print("ImageWidget\n");
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 2,
      ),
      child: Image(
        image: (widget.message as ImageMessage).imageProvider,
        fit: BoxFit.fitWidth,
      ),
    );
  }
  Widget _buildTextMessage() {
    Color decorationColor = (widget.isSentByMe) ? Colors.red : Colors.grey[300];
    Color textColor = (widget.isSentByMe) ? Colors.white : Colors.black;
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 3 * 2,
      ),
      child: Text(
        widget.message.getContent(),
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
    print(widget.message.type);
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
        padding: EdgeInsets.only(bottom: 2.0),
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

