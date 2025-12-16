import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/constants/color_constants.dart';
import 'option_sheet.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key});

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
                  child: isTyping ? _sendButton() : _micButton(),
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

  Widget _sendButton() {
    return Container(
      key: const ValueKey("send"),
      decoration: const BoxDecoration(
        color: ColorConstants.primaryColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.send, color: ColorConstants.black, size: 22),
        onPressed: () {
          debugPrint("send: " + _controller.text);
          _controller.clear();
        },
      ),
    );
  }
}
