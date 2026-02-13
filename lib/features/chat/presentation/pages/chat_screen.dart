import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:mail_messanger/features/chat/data/repositories/chat_repository.dart';
import 'package:mail_messanger/features/chat/domain/entities/message_entity.dart';
import 'package:mail_messanger/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:mail_messanger/features/chat/domain/usecases/set_typing_status_usecase.dart';
import 'package:mail_messanger/features/chat/domain/usecases/stream_typing_status_usecase.dart';

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

  late final SetTypingStatusUsecase _setTypingStatusUsecase =
      SetTypingStatusUsecase(
        ChatRepository(ChatRemoteDataSourceImpl(FirebaseFirestore.instance)),
      );

  late final StreamTypingStatusUsecase _streamTypingStatusUsecase =
      StreamTypingStatusUsecase(
        ChatRepository(ChatRemoteDataSourceImpl(FirebaseFirestore.instance)),
      );

  final ChatRepository _chatRepository = ChatRepository(
    ChatRemoteDataSourceImpl(FirebaseFirestore.instance),
  );

  final _scrollController = ScrollController();
  bool _isUserAtBottom = true;
  bool _initialScrollDone = false;
  final double _scrollThreshold = 100.0; // pixels from bottom
  String? _lastMessageId;
  List<MessageEntity> _cachedMessages =
      []; // Cache messages to prevent loading indicator

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Listen to scroll position to track if user is at bottom
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    // For reverse list, position 0 is at the bottom
    final isAtBottom = _scrollController.position.pixels <= _scrollThreshold;

    if (isAtBottom != _isUserAtBottom) {
      setState(() => _isUserAtBottom = isAtBottom);
    }
  }

  void _scrollToBottom({bool animate = true}) {
    if (!_scrollController.hasClients) return;

    if (animate) {
      _scrollController.animateTo(
        0, // For reverse list, 0 is the bottom
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(0);
    }
  }

  void _handleNewMessages(List<MessageEntity> messages) {
    if (messages.isEmpty) return;

    final latestMessage =
        messages.first; // First item in reversed list is newest
    final latestMessageId =
        '${latestMessage.chatId}_${latestMessage.createdAt.millisecondsSinceEpoch}';

    // Check if this is a new message
    final isNewMessage = _lastMessageId != latestMessageId;
    _lastMessageId = latestMessageId;

    if (!isNewMessage) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Auto-scroll if:
      // 1. Initial load (first time opening chat)
      // 2. User is already at/near bottom
      // 3. User sent the message themselves
      final shouldAutoScroll =
          !_initialScrollDone ||
          _isUserAtBottom ||
          latestMessage.senderId == widget.currentUserId;

      if (shouldAutoScroll) {
        _scrollToBottom(animate: _initialScrollDone);
      }

      _initialScrollDone = true;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
          chatId: widget.chatRoomId,
          streamTypingStatusUsecase: _streamTypingStatusUsecase,
        ),
      ),
      body: StreamBuilder<List<MessageEntity>>(
        stream: _chatRepository.getMessages(widget.chatRoomId),
        builder: (context, snapshot) {
          // Use cached messages if snapshot has no data (prevents loading indicator)
          final messages = snapshot.hasData ? snapshot.data! : _cachedMessages;

          // Only show loading indicator on true initial load (no cached messages)
          if (messages.isEmpty && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Update cache when new data arrives
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            _cachedMessages = snapshot.data!;
          }

          if (messages.isEmpty) {
            return const Center(child: Text('No messages yet'));
          }

          // Handle new messages and auto-scroll logic
          _handleNewMessages(messages);

          // Reverse the list so newest messages are at index 0
          final reversedMessages = messages.reversed.toList();

          return ListView.builder(
            controller: _scrollController,
            reverse: true, // Makes the list start from bottom
            itemCount: reversedMessages.length,
            addAutomaticKeepAlives: false, // Optimize performance
            addRepaintBoundaries: true, // Optimize rendering
            itemBuilder: (context, index) {
              final message = reversedMessages[index];
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
        setTypingStatusUsecase: _setTypingStatusUsecase,
        onMessageSent: () {
          // Always scroll to bottom when user sends a message
          _scrollToBottom();
        },
      ),
    );
  }
}
