import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:mail_messanger/features/chat/data/repositories/chat_repository.dart';
import 'package:mail_messanger/features/chat/domain/entities/message_entity.dart';
import 'package:mail_messanger/features/chat/domain/usecases/send_message_usecase.dart';

import '../widgets/chat_appbar_widget.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/message_bubble_widget.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String otherUserName;
  final String? otherUserImage;
  final String otherUserId;
  final String currentUserId;

  const ChatScreen({
    super.key,
    required this.chatRoomId,
    required this.otherUserName,
    required this.otherUserImage,
    required this.otherUserId,
    required this.currentUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  late final SendMessageUsecase _sendMessageUsecase = SendMessageUsecase(
    ChatRepository(ChatRemoteDataSourceImpl(FirebaseFirestore.instance)),
  );

  final ChatRepository _chatRepository = ChatRepository(
    ChatRemoteDataSourceImpl(FirebaseFirestore.instance),
  );

  final _scrollController = ScrollController();
  int _lastMessageCount = 0;
  bool _initialLoadDone = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ChatAppbarWidget(
          otherUserName: widget.otherUserName,
          otherPhotoUrl: widget.otherUserImage,
          otherUserId: widget.otherUserId,
        ),
      ),
      body: StreamBuilder<List<MessageEntity>>(
        stream: _chatRepository.getMessages(widget.chatRoomId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (!_initialLoadDone) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const SizedBox.shrink();
            }
          }

          final messages = snapshot.data!;
          _initialLoadDone = true;

          if (messages.length > _lastMessageCount) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });

            _lastMessageCount = messages.length;
          }

          if (messages.isEmpty) {
            return const Center(child: Text('No messages yet'));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: messages.length,

            itemBuilder: (context, index) {
              final message = messages[index];

              final isMe = message.senderId == widget.currentUserId;

              return MessageBubbleWidget(
                isMe: isMe,
                message: message.message,
                timestamp: message.createdAt,
              );
            },
          );
        },
      ),
      bottomNavigationBar: ChatInputBar(
        chatId: widget.chatRoomId,
        currentUserId: widget.currentUserId,
        otherUserId: widget.otherUserId,
        sendMessageUsecase: _sendMessageUsecase,
      ),
    );
  }
}
