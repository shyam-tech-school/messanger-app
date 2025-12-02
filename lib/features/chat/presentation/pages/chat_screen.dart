import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';

import '../widgets/chat_appbar_widget.dart';
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
      bottomNavigationBar: _buildInputBars(context),
    );
  }

  Widget _buildInputBars(BuildContext context) {
    return SafeArea(
      bottom: false,
      minimum: const .only(bottom: 10),
      child: Container(
        color: ColorConstants.white,
        padding: .only(
          left: 16,
          right: 10,
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorConstants.scaffoldSecondary,
                  hintText: "Type here..",
                  border: OutlineInputBorder(
                    borderRadius: .circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                cursorColor: ColorConstants.primary,
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.photo_camera),
            ),
            IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.mic)),
          ],
        ),
      ),
    );
  }
}
