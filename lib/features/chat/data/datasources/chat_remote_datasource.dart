import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mail_messanger/features/chat/domain/entities/message_entity.dart';

abstract class ChatRemoteDatasource {
  Future<String> startChat(String currentUserId, String otherUserId);
  Future<void> sendMessage(MessageEntity message);
  Stream<List<MessageEntity>> getMessages(String chatId);
  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String userId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDatasource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl(this.firestore);

  @override
  Future<String> startChat(String currentUserId, String otherUserId) async {
    final chatId = _getChatId(currentUserId, otherUserId);

    await firestore.collection('chats').doc(chatId).set({
      'chatId': chatId,
      'participants': [currentUserId, otherUserId],
      'participantsMap': {currentUserId: true, otherUserId: true},
      'chatType': "one-to-one",
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return chatId;
  }

  // chat room id generator
  String _getChatId(String currentUserId, String otherUserId) =>
      currentUserId.compareTo(otherUserId) < 0
      ? "${currentUserId}_$otherUserId"
      : "${otherUserId}_$currentUserId";

  // Get messages
  @override
  Stream<List<MessageEntity>> getMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((e) {
            final data = e.data();
            return MessageEntity(
              chatId: chatId,
              senderId: data['senderId'],
              receiverId: data['receiverId'],
              message: data['message'],
              type: data['type'],
              mediaUrl: data['mediaUrl'],
              createdAt: (data['createdAt'] as Timestamp).toDate(),
            );
          }).toList();
        });
  }

  // Send messages
  @override
  Future<void> sendMessage(MessageEntity message) async {
    final chatRef = firestore.collection('chats').doc(message.chatId);

    // Add message
    await chatRef.collection('messages').add({
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'message': message.message,
      'type': message.type,
      'mediaUrl': message.mediaUrl,
      'isSeen': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update chat metadata(summary)
    await chatRef.update({
      'lastMessage': message.message,
      'lastMessageType': message.type,
      'lastMessageSenderId': message.senderId,
      'lastMessageTime': FieldValue.serverTimestamp(),

      // Unread messsage count
      'unreadCount.${message.receiverId}': FieldValue.increment(1),
      'unreadCount.${message.senderId}': 0,

      // Typing reset
      'typing.${message.senderId}': false,
    });
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String userId) {
    return firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }
}
