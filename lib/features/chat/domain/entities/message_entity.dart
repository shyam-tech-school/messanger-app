class MessageEntity {
  final String chatId;
  final String senderId;
  final String receiverId;
  final String message;
  final String type; // text | image | audio | video
  final String? mediaUrl;
  final DateTime createdAt;

  MessageEntity({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    required this.mediaUrl,
    required this.createdAt,
  });
}
