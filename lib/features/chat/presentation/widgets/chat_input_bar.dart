import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mail_messanger/features/chat/domain/entities/message_entity.dart';
import 'package:mail_messanger/features/chat/domain/usecases/send_message_usecase.dart';

import '../../../../core/constants/color_constants.dart';
import 'option_sheet.dart';

class ChatInputBar extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String otherUserId;
  final SendMessageUsecase sendMessageUsecase;

  const ChatInputBar({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.otherUserId,
    required this.sendMessageUsecase,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool isTyping = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final typing = _controller.text.trim().isNotEmpty;
      if (typing != isTyping) {
        setState(() => isTyping = typing);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      // color: Colors.white,
      //color: ColorConstants.textfieldFillColor,
      color: ColorConstants.darkScaffoldBgColor,
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return const OptionSheet();
                    },
                    useSafeArea: true,
                    backgroundColor: ColorConstants.textfieldFillColor,
                  );
                },
                icon: const Icon(Ionicons.link_outline),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 6,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    filled: true,
                    fillColor: ColorConstants.textfieldFillColor,
                    hintText: "Type a message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  cursorColor: ColorConstants.primaryColor,
                ),
              ),

              const SizedBox(width: 6),

              SizedBox(
                width: 50,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  child: isTyping ? _sendMessage() : _micButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _micButton() {
    return IconButton(
      key: const ValueKey("mic"),
      icon: const Icon(CupertinoIcons.mic),
      onPressed: () {},
    );
  }

  Widget _sendMessage() {
    return Container(
      key: const ValueKey("send"),
      decoration: const BoxDecoration(
        color: ColorConstants.primaryColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.send, color: ColorConstants.black, size: 22),
        onPressed: () async {
          final text = _controller.text.trim();
          if (text.isEmpty) return;

          // Clear controller
          _controller.clear();

          await widget.sendMessageUsecase(
            MessageEntity(
              chatId: widget.chatId,
              senderId: widget.currentUserId,
              receiverId: widget.otherUserId,
              message: text,
              type: "text",
              mediaUrl: null,
              createdAt: DateTime.now(),
            ),
          );

          // clear controller
          _controller.clear();
        },
      ),
    );
  }
}
