import 'package:flutter/material.dart';

import 'package:ChatApp/src/models/conversation/conversation.dart';

import 'package:ChatApp/src/screens/conversation_screens/widgets/input_widget.dart';
import 'package:ChatApp/src/screens/conversation_screens/widgets/conversation_app_bar.dart';
import 'package:ChatApp/src/screens/conversation_screens/widgets/message_list_widget.dart';

import '../../models/conversation/conversation.dart';


class ConversationScreen extends StatefulWidget {
  final Conversation conversation;
  ConversationScreen(this.conversation);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

ConversationScreen fakeConversationScreen() {
  return ConversationScreen(fakeConversation());
}

class _ConversationScreenState extends State<ConversationScreen> {
  String _uid;
  String get uid {
    return _uid;
  }
  set uid(String newUid) {
    this._uid = newUid;
  }
  @override
  Widget build(BuildContext context) {
    _uid = "0";
    return SafeArea(
      child: Scaffold(
        appBar: conversationAppBar(widget.conversation),
        body: Stack(
          children: [
            Column(
              children: [
                MessageListWidget(widget.conversation.messageList, uid),
                InputWidget(),
              ],
            )
          ],
        )
      ),
    );
  }
}
