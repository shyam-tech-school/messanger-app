import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mail_messanger/features/chat/domain/entities/message_entity.dart';

abstract class IChatRepositories {
  Future<String> startChat(String currentUserid, String otherUserid);
  Future<void> sendMessage(MessageEntity messageEntity);
  Stream<List<MessageEntity>> getMessages(String chatId);
  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String userId);

  // Typing
  Future<void> setTypingStatus(String chatId, String userId, bool isTyping);
  Stream<bool> streamTypingStatus(String chatId, String userId);

  // Unread count
  Future<void> resetUnreadCount(String chatId, String userId);

  // Delivery status
  Future<void> markMessagesDelivered(String chatId, String receiverId);

  // Delete chat (soft-delete: remove current user from participants)
  Future<void> deleteChat(String chatId, String currentUserId);
}
