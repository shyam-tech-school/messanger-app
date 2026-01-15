import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:mail_messanger/features/chat/data/repositories/chat_repository.dart';
import 'package:mail_messanger/features/chat/domain/usecases/send_message_usecase.dart';

import '../widgets/chat_appbar_widget.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/message_bubble_widget.dart';

class ChatScreen extends StatelessWidget {
  final String chatRoomId;
  final String otherUserName;
  final String? otherUserImage;
  final String otherUserId;
  final String currentUserId;

  ChatScreen({
    super.key,
    required this.chatRoomId,
    required this.otherUserName,
    required this.otherUserImage,
    required this.otherUserId,
    required this.currentUserId,
  });

  late final SendMessageUsecase _sendMessageUsecase = SendMessageUsecase(
    ChatRepository(ChatRemoteDataSourceImpl(FirebaseFirestore.instance)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ChatAppbarWidget(
          otherUserName: otherUserName,
          otherPhotoUrl: otherUserImage,
        ),
      ),
      body: ListView.builder(
        reverse: false,
        itemCount: 2,
        itemBuilder: (context, index) {
          return const MessageBubbleWidget();
        },
      ),
      bottomNavigationBar: ChatInputBar(
        chatId: chatRoomId,
        currentUserId: currentUserId,
        otherUserId: otherUserId,
        sendMessageUsecase: _sendMessageUsecase,
      ),
    );
  }
}
