import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mail_messanger/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:mail_messanger/features/chat/domain/entities/message_entity.dart';
import 'package:mail_messanger/features/chat/domain/repositories/i_chat_repositories.dart';

class ChatRepository implements IChatRepositories {
  final ChatRemoteDatasource remoteDs;

  ChatRepository(this.remoteDs);

  @override
  Future<String> startChat(String currentUserId, String otherUserId) {
    return remoteDs.startChat(currentUserId, otherUserId);
  }

  @override
  Stream<List<MessageEntity>> getMessages(String chatId) {
    return remoteDs.getMessages(chatId);
  }

  @override
  Future<void> sendMessage(MessageEntity message) {
    return remoteDs.sendMessage(message);
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String userId) {
    return remoteDs.streamChats(userId);
  }

  @override
  Future<void> setTypingStatus(String chatId, String userId, bool isTyping) {
    return remoteDs.setTypingStatus(chatId, userId, isTyping);
  }

  @override
  Stream<bool> streamTypingStatus(String chatId, String userId) {
    return remoteDs.streamTypingStatus(chatId, userId);
  }

  @override
  Future<void> resetUnreadCount(String chatId, String userId) {
    return remoteDs.resetUnreadCount(chatId, userId);
  }
}
