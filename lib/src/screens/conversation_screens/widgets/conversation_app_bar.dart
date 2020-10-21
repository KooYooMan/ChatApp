import 'package:flutter/material.dart';

import 'package:ChatApp/src/models/conversation/conversation.dart';

Widget conversationAppBar(Conversation conversation) {
  return AppBar(
    title: Text(conversation.displayName),
  );
}

