import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';

import '../widgets/chat_appbar_widget.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/message_bubble_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.chats});

  final Map<String, dynamic> chats;

  @override
  Widget build(BuildContext context) {
    final messages = chats['messages'] as List;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorConstants.scaffoldSecondary,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ChatAppbarWidget(chats: chats),
      ),
      body: ListView.builder(
        reverse: false,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          debugPrint(message.toString());

          return MessageBubbleWidget(message: message);
        },
      ),
      bottomNavigationBar: const ChatInputBar(),
    );
  }
}
